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
    }
}
