using eBolnica.Model;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services
{
    public class OdjelService : BaseCRUDService<Odjel, OdjelSearchObject, Database.Odjel, OdjelInsertRequest, OdjelUpdateRequest>, IOdjelService
    {
        public OdjelService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Database.Odjel> AddFilter(OdjelSearchObject searchObject, IQueryable<Database.Odjel> query)
        {
            query = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject?.NazivGTE))
            {
                query = query.Where(x => x.Naziv.StartsWith(searchObject.NazivGTE));
            }
            return query;
        }
    }
}
