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
            return base.AddFilter(search, query).Include(x => x.MedicinskoOsoblje).ThenInclude(k => k.Korisnik).Include(y => y.RasporedSmjena);
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
                .Any(x => x.RasporedSmjenaId == request.RasporedSmjenaId && x.KorisnikId == osoblje.Korisnik.KorisnikId);

            if (!rasporedSmjene)
            {
                throw new Exception("Smjena na taj dan ne postoji za tog korisnika.");
            }

            base.BeforeInsert(request, entity);
        }
    }
}
