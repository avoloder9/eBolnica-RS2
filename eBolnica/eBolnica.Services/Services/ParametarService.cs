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
    public class ParametarService : BaseCRUDService<Parametar, ParametarSearchObject, Database.Parametar, ParametarInsertRequest, ParametarUpdateRequest>, IParametarService
    {
        public ParametarService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Database.Parametar> AddFilter(ParametarSearchObject searchObject, IQueryable<Database.Parametar> query)
        {
            query = base.AddFilter(searchObject, query).Where(x => x.Obrisano == false);

            if (!string.IsNullOrWhiteSpace(searchObject?.Naziv))
            {
                query = query.Where(x => x.Naziv.StartsWith(searchObject.Naziv));
            }
            return query;
        }
    }
}
