using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.UputnicaStateMachine
{
    public class InitialUputnicaState : BaseUputnicaState
    {
        public InitialUputnicaState(Database.EBolnicaContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override Uputnica Insert(UputnicaInsertRequest request)
        {
            var set = Context.Set<Database.Uputnica>();
            var entity = Mapper.Map<Database.Uputnica>(request);
            entity.StateMachine = "draft";
            set.Add(entity);
            Context.SaveChanges();
            return Mapper.Map<Uputnica>(entity);
        }
        public override List<string> AllowedActions(Database.Uputnica entity)
        {
            return new List<string>() { nameof(Insert) };
        }
    }
}
