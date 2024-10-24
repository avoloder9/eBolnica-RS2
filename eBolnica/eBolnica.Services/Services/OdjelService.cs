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
    public class OdjelService : BaseCRUDService<Odjel, OdjelSearchObject, Database.Odjel, OdjelInsertRequest, OdjelUpdateRequest>, IOdjelService
    {
        public OdjelService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Database.Odjel> AddFilter(OdjelSearchObject searchObject, IQueryable<Database.Odjel> query)
        {
            query = base.AddFilter(searchObject, query).Include(x => x.Bolnica);


            if (!string.IsNullOrWhiteSpace(searchObject?.NazivGTE))
            {
                query = query.Where(x => x.Naziv.StartsWith(searchObject.NazivGTE));
            }
            return query;
        }

        public override void BeforeUpdate(OdjelUpdateRequest request, Database.Odjel entity)
        {

            if (request.GlavniDoktorId != 0)
            {
                var doktorExists = Context.Set<Database.Doktor>().Any(d => d.DoktorId == request.GlavniDoktorId);
                if (!doktorExists)
                {
                    throw new Exception("Glavni doktor s tim Id-om ne postoji");
                }
                entity.GlavniDoktorId = request.GlavniDoktorId;
            }
            else
            {
                entity.GlavniDoktorId = null;
            }
        }
    }
}

