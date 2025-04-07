using eBolnica.Model;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Database;
using eBolnica.Services.Interfaces;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.Services
{
    public abstract class BaseService<TModel, TSearch, TDbEntity> : IService<TModel, TSearch> where TSearch : BaseSearchObject where TDbEntity : class where TModel : class
    {
        public EBolnicaContext Context { get; set; }
        public IMapper Mapper { get; }

        public BaseService(EBolnicaContext context, IMapper mapper)
        {
            Context = context;
            Mapper = mapper;
        }

        public virtual PagedResult<TModel> GetPaged(TSearch search)
        {
            List<TModel> result = new List<TModel>();
            var query = Context.Set<TDbEntity>().AsQueryable();

            query = AddFilter(search, query);


            int count = query.Count();

            if (search?.Page.HasValue == true && search.PageSize.HasValue == true)
            {
                query = query.Skip(search.Page.Value * search.PageSize.Value).Take(search.PageSize.Value);
            }

            var list = query.ToList();

            var resultList = Mapper.Map(list, result);

            PagedResult<TModel> response = new PagedResult<TModel>();
            response.ResultList = resultList;
            response.Count = count;
            return response;
        }
        public virtual IQueryable<TDbEntity> AddFilter(TSearch search, IQueryable<TDbEntity> query)
        {
            return query;
        }
        public virtual TModel GetById(int id)
        {
            var entity = Context.Set<TDbEntity>().Find(id);
            if (entity != null)
            {
                return Mapper.Map<TModel>(entity);
            }
            else
            {
                return null!;
            }
        }
    }
}
