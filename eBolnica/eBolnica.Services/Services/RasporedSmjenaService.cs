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

        public async Task GenerisiRasporedSmjena(DateTime startDate, DateTime endDate)
        {
            var doktori = await Context.Doktors.AsNoTracking().Select(d => d.KorisnikId).ToListAsync();
            var osoblje = await Context.MedicinskoOsobljes.AsNoTracking().Select(o => o.KorisnikId).ToListAsync();
            var odjeli = await Context.Odjels.AsNoTracking().ToListAsync();
            var smjene = await Context.Smjenas.AsNoTracking().ToListAsync();


            var doktorSmjeneCount = doktori.ToDictionary(d => d, d => 0);
            var osobljeSmjeneCount = osoblje.ToDictionary(o => o, o => 0);

            for (var date = startDate; date <= endDate; date = date.AddDays(1))
            {
                var yesterday = date.AddDays(-1);

                foreach (var odjel in odjeli)
                {
                    foreach (var smjena in smjene)
                    {
                        var dostupniDoktori = DohvatiDostupneDoktore(doktori, date, doktorSmjeneCount);
                        var dostupnoOsoblje = DohvatiDostupnoOsoblje(osoblje, date, osobljeSmjeneCount);

                        if (!dostupniDoktori.Any() || dostupnoOsoblje.Count < 2)
                        {
                            var jucerasnjiRadnici = DohvatiJučerašnjeRadnike(
                                yesterday, doktori, osoblje, doktorSmjeneCount, osobljeSmjeneCount);

                            dostupniDoktori = jucerasnjiRadnici.Where(d => doktori.Contains(d)).ToList();
                            dostupnoOsoblje = jucerasnjiRadnici.Where(o => osoblje.Contains(o)).ToList();
                        }


                        if (dostupnoOsoblje.Count < 2)
                        {
                            dostupnoOsoblje = DopuniOsobljeJučerašnjim(yesterday, dostupnoOsoblje, osoblje, osobljeSmjeneCount);
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

                        if (!ValidirajUnos(doktor, osoblje1, osoblje2, smjena, date))
                        {
                            continue;
                        }

                        doktorSmjeneCount[doktor]++;
                        osobljeSmjeneCount[osoblje1]++;
                        osobljeSmjeneCount[osoblje2]++;

                        Context.RasporedSmjenas.AddRange(new List<Database.RasporedSmjena>
                {
                    new Database.RasporedSmjena { SmjenaId = smjena.SmjenaId, KorisnikId = doktor, Datum = date },
                    new Database.RasporedSmjena { SmjenaId = smjena.SmjenaId, KorisnikId = osoblje1, Datum = date },
                    new Database.RasporedSmjena { SmjenaId = smjena.SmjenaId, KorisnikId = osoblje2, Datum = date }
                });
                    }
                }
            }

            await Context.SaveChangesAsync();
        }
        private List<int> DohvatiDostupneDoktore(List<int> doktori, DateTime date, Dictionary<int, int> doktorSmjeneCount)
        {
            return doktori
                .Where(d => !Context.SlobodniDans.Any(s => s.KorisnikId == d && s.Datum.Date == date.Date && (s.Status ?? false)))
                .OrderBy(d => doktorSmjeneCount[d])
                .ToList();
        }
        private List<int> DohvatiDostupnoOsoblje(List<int> osoblje, DateTime date, Dictionary<int, int> osobljeSmjeneCount)
        {
            return osoblje
                .Where(o => !Context.SlobodniDans.Any(s => s.KorisnikId == o && s.Datum.Date == date.Date && (s.Status ?? false)))
                .OrderBy(o => osobljeSmjeneCount[o])
                .ToList();
        }
        private List<int> DohvatiJučerašnjeRadnike(DateTime yesterday, List<int> doktori, List<int> osoblje, Dictionary<int, int> doktorSmjeneCount, Dictionary<int, int> osobljeSmjeneCount)
        {
            return Context.RasporedSmjenas.Where(r => r.Datum.Date == yesterday.Date)
                .Select(r => r.KorisnikId).Distinct()
                .Where(d => doktori.Contains(d) || osoblje.Contains(d)) // Uključuje i doktore i osoblje
                .OrderBy(d => doktori.Contains(d) ? (doktorSmjeneCount.ContainsKey(d) ? doktorSmjeneCount[d] : int.MaxValue) :
                        (osobljeSmjeneCount.ContainsKey(d) ? osobljeSmjeneCount[d] : int.MaxValue)
                ).ToList();
        }
        private List<int> DopuniOsobljeJučerašnjim(DateTime yesterday, List<int> dostupnoOsoblje, List<int> osoblje, Dictionary<int, int> osobljeSmjeneCount)
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

            return dostupnoOsoblje;
        }
        private bool ValidirajUnos(int doktor, int osoblje1, int osoblje2, Database.Smjena smjena, DateTime date)
        {
            if (!Context.Smjenas.Any(s => s.SmjenaId == smjena.SmjenaId))
                throw new Exception("Smjena sa zadanim ID-om ne postoji");

            if (!Context.Korisniks.Any(k => k.KorisnikId == doktor || k.KorisnikId == osoblje1 || k.KorisnikId == osoblje2))
                throw new Exception("Jedan od korisnika sa zadanim ID-om ne postoji");

            if (Context.SlobodniDans.Any(s => (s.KorisnikId == doktor || s.KorisnikId == osoblje1 || s.KorisnikId == osoblje2)
                && s.Datum.Date == date.Date && s.Status == true))
            {
                throw new Exception("Jedan od korisnika ima odobren slobodan dan na ovaj datum.");
            }

            return true;
        }

    }
}