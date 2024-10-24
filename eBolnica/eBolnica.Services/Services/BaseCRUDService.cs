using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore.Diagnostics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.Services
{
    public abstract class BaseCRUDService<TModel, TSearch, TDbEntity, TInsert, TUpdate> : BaseService<TModel, TSearch, TDbEntity> where TModel : class where TDbEntity : class
        where TSearch : BaseSearchObject
    {
        public BaseCRUDService(EBolnicaContext context, IMapper mapper) : base(context, mapper)
        { }
        public TModel Insert(TInsert request)
        {
            TDbEntity entity = Mapper.Map<TDbEntity>(request);
            BeforeInsert(request, entity);
            Context.Add(entity);
            Context.SaveChanges();

            return Mapper.Map<TModel>(entity);
        }

        public virtual void BeforeInsert(TInsert request, TDbEntity entity) { }
        public virtual TModel Update(int id, TUpdate request)
        {
            var set = Context.Set<TDbEntity>();
            var entity = set.Find(id);
            if (entity == null) { throw new Exception("Nije pronadjen"); }
            Mapper.Map(request, entity);
            BeforeUpdate(request, entity);
            Context.SaveChanges();
            return Mapper.Map<TModel>(entity);
        }
        public virtual void BeforeUpdate(TUpdate request, TDbEntity entity) { }
    }
}
