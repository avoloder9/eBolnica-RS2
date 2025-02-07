using Azure.Core;
using eBolnica.Model.Requests;
using eBolnica.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.UputnicaStateMachine
{
    public class DraftUputnicaState : BaseUputnicaState
    {
        public DraftUputnicaState(EBolnicaContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }
        //public override Model.Models.Uputnica Update(int id, UputnicaUpdateRequest request)
        //{
        //    var set = Context.Set<Database.Uputnica>();
        //    var entity = set.Find(id);
        //    Mapper.Map(request, entity);
        //    Context.SaveChanges();
        //    return Mapper.Map<Model.Models.Uputnica>(entity);
        //}
        public override Model.Models.Uputnica Activate(int id)
        {
            var set = Context.Set<Database.Uputnica>();
            var entity = set.Find(id);
            entity.StateMachine = "active";
            Context.SaveChanges();
            return Mapper.Map<Model.Models.Uputnica>(entity);
        }
        public override Model.Models.Uputnica Hide(int id)
        {
            var set = Context.Set<Database.Uputnica>();
            var entity = set.Find(id);
            entity.StateMachine = "hidden";
            Context.SaveChanges();
            return Mapper.Map<Model.Models.Uputnica>(entity);
        }
        public override List<string> AllowedActions(Uputnica entity)
        {
            return new List<string>() { nameof(Activate),
                                                          nameof(Hide) };
                // nameof(Update),
        }
    }
}
