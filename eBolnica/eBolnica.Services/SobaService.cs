using eBolnica.Model;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using MapsterMapper;
using Microsoft.Identity.Client.Extensibility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services
{
    public class SobaService : BaseCRUDService<Soba, SobaSearchObject, Database.Soba, SobaInsertRequest, SobaUpdateRequest>, ISobaService
    {
        public SobaService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Database.Soba> AddFilter(SobaSearchObject searchObject, IQueryable<Database.Soba> query)
        {
            query = base.AddFilter(searchObject, query);

            if (searchObject?.SobaId != null && searchObject.SobaId > 0)
            {
                query = query.Where(x => x.SobaId == searchObject.SobaId);
            }
            return query;
        }
        public override void BeforeInsert(SobaInsertRequest request, Database.Soba entity)
        {
            var odjelExists = Context.Set<Database.Odjel>().Any(d => d.OdjelId == request.OdjelId);
            if (!odjelExists)
            {
                throw new Exception("Odjel s tim Id-om ne postoji");
            }
            var odjel = Context.Set<Database.Odjel>().Find(request.OdjelId);
            odjel.BrojSoba++;
            Context.SaveChanges();
            entity.Odjel = odjel;
            base.BeforeInsert(request, entity);
        }
    }
}
