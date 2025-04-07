using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.Services
{
    public class SmjenaService : BaseCRUDService<Smjena, SmjenaSearchObject, Database.Smjena, SmjenaInsertRequest, SmjenaUpdateRequest>, ISmjenaService
    {
        public SmjenaService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Database.Smjena> AddFilter(SmjenaSearchObject searchObject, IQueryable<Database.Smjena> query)
        {
            query = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject?.NazivSmjene))
            {
                query = query.Where(x => x.NazivSmjene!.StartsWith(searchObject.NazivSmjene));
            }

            return query;
        }
    }
}
