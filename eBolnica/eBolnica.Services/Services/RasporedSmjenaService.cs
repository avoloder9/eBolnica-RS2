using eBolnica.Model;
using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Database;
using eBolnica.Services.Interfaces;
using Mapster;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.Services
{
    public class RasporedSmjenaService : BaseCRUDService<Model.Models.RasporedSmjena, RasporedSmjenaSearchObject, Database.RasporedSmjena, RasporedSmjenaInsertRequest, RasporedSmjenaUpdateRequest>, IRasporedSmjenaService
    {
        public RasporedSmjenaService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Database.RasporedSmjena> AddFilter(RasporedSmjenaSearchObject searchObject, IQueryable<Database.RasporedSmjena> query)
        {
            query = base.AddFilter(searchObject, query)
                .Include(x => x.Smjena)
                .Include(x => x.Korisnik)
                .OrderBy(x => x.Datum)
                .ThenBy(x => x.SmjenaId).Where(x => x.Datum.Date >= DateTime.Now.Date);

            if (searchObject?.SmjenaId != null && searchObject.SmjenaId > 0)
            {
                query = query.Where(x => x.SmjenaId == searchObject.SmjenaId);
            }
            if (searchObject?.KorisnikId != null && searchObject.KorisnikId > 0)
            {
                query = query.Where(x => x.KorisnikId == searchObject.KorisnikId);
            }
            if (searchObject?.Datum.HasValue == true)
            {
                query = query.Where(x => x.Datum.Date == searchObject.Datum.Value.Date);
            }
            if (searchObject?.OdjelId != null && searchObject!.OdjelId > 0)
            {
                query = query.Where(x =>
                    Context.Doktors.Any(d => d.KorisnikId == x.KorisnikId && d.OdjelId == searchObject.OdjelId) ||
                    Context.MedicinskoOsobljes.Any(m => m.KorisnikId == x.KorisnikId && m.OdjelId == searchObject.OdjelId)
                );
            }
            query = query.Where(x => !Context.RadniSatis.Any(rs => rs.RasporedSmjenaId == x.RasporedSmjenaId && rs.VrijemeOdlaska.HasValue));

            return query;
        }

        public override void BeforeInsert(RasporedSmjenaInsertRequest request, Database.RasporedSmjena entity)
        {
            var smjenaExists = Context.Smjenas.Any(s => s.SmjenaId == request.SmjenaId);
            if (!smjenaExists)
            {
                throw new Exception("Smjena sa zadanim ID-om ne postoji");
            }
            var isKorisnik = Context.Korisniks.Any(k => k.KorisnikId == request.KorisnikId);
            if (!isKorisnik)
            {
                throw new Exception("Korisnik sa zadanim ID-om ne postoji");
            }

            var slobodanDan = Context.SlobodniDans.FirstOrDefault(s => s.KorisnikId == request.KorisnikId
            && s.Datum.Date == request.Datum.Date && s.Status == true);

            if (slobodanDan != null)
            {
                throw new UserException("Korisnik ima odobren slobodan dan na ovaj datum i ne može biti dodan u smjenu.");
            }
            base.BeforeInsert(request, entity);
        }
        public override void BeforeUpdate(RasporedSmjenaUpdateRequest request, Database.RasporedSmjena entity)
        {
            var smjenaExists = Context.Smjenas.Any(s => s.SmjenaId == request.SmjenaId);
            if (!smjenaExists)
            {
                throw new Exception("Smjena sa zadanim ID-om ne postoji");
            }
            var korisnikExists = Context.Korisniks.Any(k => k.KorisnikId == request.KorisnikId);
            if (!korisnikExists)
            {
                throw new Exception("Korisnik sa zadanim ID-om ne postoji");
            }
            request.Adapt(entity);
            base.BeforeUpdate(request, entity);
        }
        public async Task GenerisiRasporedSmjena(DateTime startDate, DateTime endDate)
        {
            var osoblje = await Context.MedicinskoOsobljes.AsNoTracking().Select(o => o.KorisnikId).ToListAsync();
            var odjeli = await Context.Odjels.AsNoTracking().ToListAsync();
            var smjene = await Context.Smjenas.AsNoTracking().ToListAsync();

            var slobodniDani = await Context.SlobodniDans.AsNoTracking().Where(s => s.Datum >= startDate && s.Datum <= endDate).ToListAsync();

            var sviRasporedi = await Context.RasporedSmjenas.Include(rs => rs.Smjena).Where(rs => rs.Datum >= startDate.AddDays(-1) && rs.Datum <= endDate).ToListAsync();

            var rasporedPoDanu = new Dictionary<DateTime, HashSet<int>>();

            for (var date = startDate; date <= endDate; date = date.AddDays(1))
            {
                rasporedPoDanu[date] = new HashSet<int>();

                foreach (var odjel in odjeli)
                {
                    foreach (var smjena in smjene)
                    {
                        var brojRadnikaPoSmjeni = osoblje.Count / (smjene.Count * odjeli.Count);

                        var dostupnoOsoblje = osoblje.Where(o => !rasporedPoDanu[date].Contains(o) && !JeRadioTrecePrekoNoci(o, date, sviRasporedi) &&
                                !ImaSlobodanDan(o, date, slobodniDani))
                            .OrderBy(o => sviRasporedi.Count(rs => rs.KorisnikId == o)).ToList();

                        if (dostupnoOsoblje.Count < brojRadnikaPoSmjeni)
                        {
                            Console.WriteLine($"Nedovoljno osoblja za odjel {odjel.Naziv} smjena {smjena.NazivSmjene} na datum {date}");
                            continue;
                        }

                        var dodijeljenoOsoblje = dostupnoOsoblje.Take(brojRadnikaPoSmjeni).ToList();

                        foreach (var o in dodijeljenoOsoblje)
                        {
                            rasporedPoDanu[date].Add(o);

                            var noviRaspored = new Database.RasporedSmjena
                            {
                                SmjenaId = smjena.SmjenaId,
                                KorisnikId = o,
                                Datum = date,
                            };

                            Context.RasporedSmjenas.Add(noviRaspored);
                        }
                    }
                }
            }

            await Context.SaveChangesAsync();
        }
        private bool JeRadioTrecePrekoNoci(int korisnikId, DateTime currentDate, List<Database.RasporedSmjena> sviRasporedi)
        {
            var danPrije = currentDate.AddDays(-1).Date;

            return sviRasporedi.Any(rs =>
                rs.KorisnikId == korisnikId &&
                rs.Datum.Date == danPrije &&
                rs.Smjena != null &&
                rs.Smjena.NazivSmjene == "Treća");
        }
        private bool ImaSlobodanDan(int korisnikId, DateTime date, List<Database.SlobodniDan> slobodniDani)
        {
            return slobodniDani.Any(s => s.KorisnikId == korisnikId && s.Datum.Date == date.Date);
        }

    }
}