using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.Services
{
    public class RadniSatiService : BaseCRUDService<RadniSati, RadniSatiSearchObject, Database.RadniSati, RadniSatiInsertRequest, RadniSatiUpdateRequest>, IRadniSatiService
    {
        public RadniSatiService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Database.RadniSati> AddFilter(RadniSatiSearchObject search, IQueryable<Database.RadniSati> query)
        {
            query = base.AddFilter(search, query)
                .Include(x => x.MedicinskoOsoblje)
                .ThenInclude(k => k.Korisnik)
                .Include(y => y.RasporedSmjena);


            if (search.RasporedSmjenaId.HasValue && search.RasporedSmjenaId.Value != 0)
            {
                query = query.Where(x => x.RasporedSmjenaId == search.RasporedSmjenaId);
            }

            if (search.AktivneSmjene == true)
            {
                query = query.Where(x => x.VrijemeDolaska != null && x.VrijemeOdlaska == null);
            }

            return query;
        }
        public override void BeforeInsert(RadniSatiInsertRequest request, Database.RadniSati entity)
        {
            var osoblje = Context.MedicinskoOsobljes
                .Include(x => x.Korisnik)
                .FirstOrDefault(x => x.MedicinskoOsobljeId == request.MedicinskoOsobljeId);
            if (osoblje == null || osoblje.Korisnik == null)
            {
                throw new Exception("Medicinsko osoblje sa zadanim ID-om ne postoji ili nema povezanog korisnika.");
            }
            var rasporedSmjene = Context.RasporedSmjenas
                .FirstOrDefault(x => x.RasporedSmjenaId == request.RasporedSmjenaId && x.KorisnikId == osoblje.Korisnik.KorisnikId);

            if (rasporedSmjene == null)
            {
                throw new Exception("Smjena ne postoji za tog korisnika.");
            }
            if (rasporedSmjene.Datum.Date != DateTime.Now.Date)
            {
                throw new Exception("Datum dolaska ne odgovara datumu smjene.");
            }
            var postojiRadniSati = Context.RadniSatis
       .Any(x => x.MedicinskoOsobljeId == request.MedicinskoOsobljeId &&
                 x.RasporedSmjenaId == request.RasporedSmjenaId &&
                 x.VrijemeDolaska.Hours == request.VrijemeDolaska.Hours &&
                 x.VrijemeDolaska.Minutes == request.VrijemeDolaska.Minutes &&
                 x.VrijemeDolaska.Seconds == request.VrijemeDolaska.Seconds);

            if (postojiRadniSati)
            {
                throw new Exception("Osoblje je već prijavilo dolazak na smjenu za taj dan.");
            }

            base.BeforeInsert(request, entity);
        }
    }
}
