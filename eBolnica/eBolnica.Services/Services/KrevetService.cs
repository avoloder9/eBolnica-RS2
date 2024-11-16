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
    public class KrevetService : BaseCRUDService<Krevet, KrevetSearchObject, Database.Krevet, KrevetInsertRequest, KrevetUpdateRequest>, IKrevetService
    {
        public KrevetService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Krevet> AddFilter(KrevetSearchObject searchObject, IQueryable<Database.Krevet> query)
        {
            query = base.AddFilter(searchObject, query).Include(x => x.Soba);

            if (searchObject?.KrevetId != null && searchObject.KrevetId > 0)
            {
                query = query.Where(x => x.SobaId == searchObject.KrevetId);
            }
            return query;
        }
        public override void BeforeInsert(KrevetInsertRequest request, Database.Krevet entity)
        {
            var sobaExists = Context.Set<Database.Soba>().Any(d => d.SobaId == request.SobaId);
            if (!sobaExists)
            {
                throw new Exception("Soba s tim Id-om ne postoji");
            }           
            var soba = Context.Set<Database.Soba>().Include(x => x.Odjel).FirstOrDefault(y => y.SobaId == request.SobaId);
            soba.BrojKreveta++;
            if (soba.Odjel != null)
            {

                soba.Odjel.BrojKreveta++;
                soba.Odjel.BrojSlobodnihKreveta++;
            }
            else
            {
                throw new Exception("Odjel za ovu sobu ne postoji");
            }            
            Context.SaveChanges();
            entity.Soba = soba;
            base.BeforeInsert(request, entity);
        }
        public override Krevet Update(int id, KrevetUpdateRequest request)
        {
            var set = Context.Set<Database.Krevet>();
            var entity = set.Find(id);
            if (entity == null) { throw new Exception("Nije pronađen"); }

            BeforeUpdate(request, entity);

            Mapper.Map(request, entity);
            Context.SaveChanges();

            return Mapper.Map<Krevet>(entity);
        }

        public override void BeforeUpdate(KrevetUpdateRequest request, Database.Krevet entity)
        {
            var novaSobaExists = Context.Sobas.Any(o => o.SobaId == request.SobaId);
            if (!novaSobaExists)
            {
                throw new Exception("Soba s navedenim ID-em ne postoji.");
            }

            var trenutniKrevet = Context.Krevets.Include(x => x.Soba).FirstOrDefault(k => k.KrevetId == entity.KrevetId);
            if (trenutniKrevet == null)
            {
                throw new Exception("Krevet nije pronađen.");
            }
            if (trenutniKrevet.SobaId != request.SobaId)
            {
                trenutniKrevet.Soba.BrojKreveta--;
                var novaSoba = Context.Sobas.Find(request.SobaId);
                novaSoba.BrojKreveta++;
            }
            Mapper.Map(request, entity);

            base.BeforeUpdate(request, entity);
        }
    }
}
