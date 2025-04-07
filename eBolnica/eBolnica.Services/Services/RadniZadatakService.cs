using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Diagnostics.Metrics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.Services
{
    public class RadniZadatakService : BaseCRUDService<RadniZadatak, RadniZadatakSearchObject, Database.RadniZadatak, RadniZadatakInsertRequest, RadniZadatakUpdateRequest>, IRadniZadatakService
    {

        public RadniZadatakService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override void BeforeInsert(RadniZadatakInsertRequest request, Database.RadniZadatak entity)
        {
            var pacijentExists = Context.Pacijents.Any(p => p.PacijentId == request.PacijentId);
            if (!pacijentExists)
            {
                throw new Exception("Pacijent sa zadanim ID-om ne postoji");
            }
            var doktorExists = Context.Doktors.Any(d => d.DoktorId == request.DoktorId);
            if (!doktorExists)
            {
                throw new Exception("Doktor sa zadanim ID-om ne postoji");
            }
            var osobljeExists = Context.MedicinskoOsobljes.Any(o => o.MedicinskoOsobljeId == request.MedicinskoOsobljeId);
            if (!osobljeExists)
            {
                throw new Exception("Osoblje sa zadanim ID-om ne postoji");
            }

            var trenutnoOsoblje = GetMedicinskoOsobljeNaSmjeni(request.DatumZadatka, request.DatumZadatka.TimeOfDay);
            if (!trenutnoOsoblje.Any(x => x.MedicinskoOsobljeId == request.MedicinskoOsobljeId))
            {
                throw new Exception("Odabrano medicinsko osoblje nije na smjeni u datom trenutku");
            }
            base.BeforeInsert(request, entity);
        }
        public override IQueryable<Database.RadniZadatak> AddFilter(RadniZadatakSearchObject searchObject, IQueryable<Database.RadniZadatak> query)
        {
            query = base.AddFilter(searchObject, query).Include(d => d.Doktor).ThenInclude(k => k.Korisnik)
                .Include(o => o.MedicinskoOsoblje).ThenInclude(x => x.Korisnik).Include(p => p.Pacijent).ThenInclude(y => y.Korisnik);

            if (searchObject?.DoktorId != null && searchObject.DoktorId > 0)
            {
                query = query.Where(x => x.DoktorId == searchObject.DoktorId);
            }
            if (searchObject?.MedicinskoOsobljeId != null && searchObject.MedicinskoOsobljeId > 0)
            {
                query = query.Where(x => x.MedicinskoOsobljeId == searchObject.MedicinskoOsobljeId);
            }
            if (searchObject?.Status.HasValue == true)
            {
                query = query.Where(x => x.Status == searchObject.Status);
            }
            return query;
        }

        public List<Database.MedicinskoOsoblje> GetMedicinskoOsobljeNaSmjeni(DateTime datumZadatka, TimeSpan vrijemeZadatka)
        {
            var trenutnoOsoblje = Context.RasporedSmjenas.Where(rs => rs.Datum.Date == datumZadatka.Date && rs.Smjena.VrijemePocetka <= vrijemeZadatka
            && rs.Smjena.VrijemeZavrsetka >= vrijemeZadatka).SelectMany(rs => rs.Korisnik.MedicinskoOsobljes).Distinct().ToList();
            return trenutnoOsoblje;
        }

    }
}
