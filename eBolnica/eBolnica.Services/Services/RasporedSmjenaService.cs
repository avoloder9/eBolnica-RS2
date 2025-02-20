using eBolnica.Model;
using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using Mapster;
using MapsterMapper;
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
            query = base.AddFilter(searchObject, query);

            if (searchObject?.SmjenaId != null && searchObject.SmjenaId > 0)
            {
                query = query.Where(x => x.SmjenaId == searchObject.SmjenaId);
            }
            if (searchObject!.Datum.HasValue)
            {
                query = query.Where(x => x.Datum.Date == searchObject.Datum.Value.Date);
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
            var endDate = startDate.AddDays(7);

            var doktorSmjeneCount = doktori.ToDictionary(d => d, d => 0);
            var osobljeSmjeneCount = osoblje.ToDictionary(o => o, o => 0);

            for (int day = 0; day < 7; day++)
            {
                var date = startDate.AddDays(day);

                var korisniciTrecaSmjenaJuce = new HashSet<int>();
                if (day > 0)
                {
                    var yesterday = date.AddDays(-1);
                    korisniciTrecaSmjenaJuce = Context.RasporedSmjenas
                        .Where(r => r.Datum.Date == yesterday.Date && r.SmjenaId == 3)
                        .Select(r => r.KorisnikId)
                        .ToHashSet();
                }

                var slobodniDoktori = doktori
                    .Where(d => doktorSmjeneCount[d] < 6 && !korisniciTrecaSmjenaJuce.Contains(d))
                    .ToList();

                var slobodnoOsoblje = osoblje
                    .Where(o => osobljeSmjeneCount[o] < 6 && !korisniciTrecaSmjenaJuce.Contains(o))
                    .ToList();

                foreach (var odjel in odjeli)
                {
                    foreach (var smjena in smjene)
                    {
                        var dostupniDoktori = slobodniDoktori.Where(d => !Context.RasporedSmjenas
                            .Any(r => r.KorisnikId == d && r.Datum.Date == date.Date)).ToList();

                        var dostupnoOsoblje = slobodnoOsoblje.Where(o => !Context.RasporedSmjenas
                            .Any(r => r.KorisnikId == o && r.Datum.Date == date.Date)).ToList();

                        if (dostupniDoktori.Count == 0 || dostupnoOsoblje.Count < 2)
                            continue;

                        var doktor = dostupniDoktori.OrderBy(d => doktorSmjeneCount[d]).First();
                        var osoblje1 = dostupnoOsoblje.OrderBy(o => osobljeSmjeneCount[o]).First();
                        dostupnoOsoblje.Remove(osoblje1);
                        var osoblje2 = dostupnoOsoblje.OrderBy(o => osobljeSmjeneCount[o]).First();

                        var korisniciSaTrecemSmjenomJuce = Context.RasporedSmjenas
                            .Where(r => r.Datum.Date == date.AddDays(-1).Date && r.SmjenaId == 3)
                            .Select(r => r.KorisnikId)
                            .ToHashSet();

                        if (korisniciSaTrecemSmjenomJuce.Contains(doktor) ||
                            korisniciSaTrecemSmjenomJuce.Contains(osoblje1) ||
                            korisniciSaTrecemSmjenomJuce.Contains(osoblje2))
                        {
                            continue;
                        }
                        if (Context.RasporedSmjenas.Any(r => r.KorisnikId == doktor && r.Datum.Date == date.Date) ||
                           Context.RasporedSmjenas.Any(r => r.KorisnikId == osoblje1 && r.Datum.Date == date.Date) ||
                           Context.RasporedSmjenas.Any(r => r.KorisnikId == osoblje2 && r.Datum.Date == date.Date))
                        {
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
