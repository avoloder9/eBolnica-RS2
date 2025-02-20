using eBolnica.Model;
using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
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
    public class RasporedSmjenaService : BaseCRUDService<RasporedSmjena, RasporedSmjenaSearchObject, Database.RasporedSmjena, RasporedSmjenaInsertRequest, RasporedSmjenaUpdateRequest>, IRasporedSmjenaService
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
                .ThenBy(x => x.SmjenaId);

            if (searchObject?.SmjenaId != null && searchObject.SmjenaId > 0)
            {
                query = query.Where(x => x.SmjenaId == searchObject.SmjenaId);
            }
            if (searchObject?.Datum.HasValue == true)
            {
                query = query.Where(x => x.Datum.Date == searchObject.Datum.Value.Date);
            }
            if (searchObject?.OdjelId != null && searchObject.OdjelId > 0)
            {
                query = query.Where(x =>
                    Context.Doktors.Any(d => d.KorisnikId == x.KorisnikId && d.OdjelId == searchObject.OdjelId) ||
                    Context.MedicinskoOsobljes.Any(m => m.KorisnikId == x.KorisnikId && m.OdjelId == searchObject.OdjelId)
                );
            }

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

        public async Task GenerisiRasporedSmjena()
        {
            var doktori = Context.Doktors.Select(d => d.KorisnikId).ToList();
            var osoblje = Context.MedicinskoOsobljes.Select(o => o.KorisnikId).ToList();
            var odjeli = Context.Odjels.ToList();
            var smjene = Context.Smjenas.ToList();

            var random = new Random();
            var startDate = DateTime.Today;

            var doktorSmjeneCount = doktori.ToDictionary(d => d, d => 0);
            var osobljeSmjeneCount = osoblje.ToDictionary(o => o, o => 0);

            for (int day = 0; day < 7; day++)
            {
                var date = startDate.AddDays(day);
                var yesterday = date.AddDays(-1);

                foreach (var odjel in odjeli)
                {
                    foreach (var smjena in smjene)
                    {
                        var dostupniDoktori = doktori
                            .Where(d => !Context.SlobodniDans.Any(s => s.KorisnikId == d && s.Datum.Date == date.Date && (s.Status ?? false)))
                            .OrderBy(d => doktorSmjeneCount[d])
                            .ToList();

                        var dostupnoOsoblje = osoblje
                            .Where(o => !Context.SlobodniDans.Any(s => s.KorisnikId == o && s.Datum.Date == date.Date && (s.Status ?? false)))
                            .OrderBy(o => osobljeSmjeneCount[o])
                            .ToList();

                        if (!dostupniDoktori.Any())
                        {
                            dostupniDoktori = Context.RasporedSmjenas
                                .Where(r => r.Datum.Date == yesterday.Date)
                                .Select(r => r.KorisnikId)
                                .Distinct()
                                .Where(d => doktori.Contains(d)) 
                                .OrderBy(d => doktorSmjeneCount[d])
                                .ToList();
                        }

                        if (dostupnoOsoblje.Count < 2)
                        {
                            var jucerasnjeOsoblje = Context.RasporedSmjenas
                                .Where(r => r.Datum.Date == yesterday.Date)
                                .Select(r => r.KorisnikId)
                                .Distinct()
                                .Where(o => osoblje.Contains(o)) 
                                .OrderBy(o => osobljeSmjeneCount[o])
                                .ToList();

                            foreach (var osoba in jucerasnjeOsoblje)
                            {
                                if (!dostupnoOsoblje.Contains(osoba) && dostupnoOsoblje.Count < 2)
                                    dostupnoOsoblje.Add(osoba);
                            }
                        }

                        var doktor = dostupniDoktori.FirstOrDefault();
                        var osoblje1 = dostupnoOsoblje.FirstOrDefault();
                        var osoblje2 = dostupnoOsoblje.Skip(1).FirstOrDefault();

                        if (doktor == 0 || osoblje1 == 0 || osoblje2 == 0)
                        {
                            doktor = doktor != 0 ? doktor : doktori.OrderBy(d => doktorSmjeneCount[d]).FirstOrDefault();
                            osoblje1 = osoblje1 != 0 ? osoblje1 : osoblje.OrderBy(o => osobljeSmjeneCount[o]).FirstOrDefault();
                            osoblje2 = osoblje2 != 0 ? osoblje2 : osoblje.OrderBy(o => osobljeSmjeneCount[o]).Skip(1).FirstOrDefault();
                        }


                        if (doktor == null || osoblje1 == null || osoblje2 == null)
                        {
                            Console.WriteLine($"UPOZORENJE: Nedostaje doktora ili osoblja za smjenu {smjena.SmjenaId} na datum {date}");
                            continue;
                        }

                        doktorSmjeneCount[doktor]++;
                        osobljeSmjeneCount[osoblje1]++;
                        osobljeSmjeneCount[osoblje2]++;

                        var smjenaExists = Context.Smjenas.Any(s => s.SmjenaId == smjena.SmjenaId);
                        if (!smjenaExists)
                        {
                            throw new Exception("Smjena sa zadanim ID-om ne postoji");
                        }

                        var isKorisnik = Context.Korisniks.Any(k => k.KorisnikId == doktor || k.KorisnikId == osoblje1 || k.KorisnikId == osoblje2);
                        if (!isKorisnik)
                        {
                            throw new Exception("Jedan od korisnika sa zadanim ID-om ne postoji");
                        }

                        var slobodanDan = Context.SlobodniDans.FirstOrDefault(s => (s.KorisnikId == doktor || s.KorisnikId == osoblje1 || s.KorisnikId == osoblje2)
                            && s.Datum.Date == date.Date && s.Status == true);

                        if (slobodanDan != null)
                        {
                            throw new Exception("Jedan od korisnika ima odobren slobodan dan na ovaj datum i ne može biti dodan u smjenu.");
                        }

                        Context.RasporedSmjenas.Add(new Database.RasporedSmjena
                        {
                            SmjenaId = smjena.SmjenaId,
                            KorisnikId = doktor,
                            Datum = date
                        });
                        Context.RasporedSmjenas.Add(new Database.RasporedSmjena
                        {
                            SmjenaId = smjena.SmjenaId,
                            KorisnikId = osoblje1,
                            Datum = date
                        });
                        Context.RasporedSmjenas.Add(new Database.RasporedSmjena
                        {
                            SmjenaId = smjena.SmjenaId,
                            KorisnikId = osoblje2,
                            Datum = date
                        });
                    }
                }

                await Context.SaveChangesAsync();
            }
        }
    }
}