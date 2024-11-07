using eBolnica.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.UputnicaStateMachine
{
    public class HiddenUputnicaState : BaseUputnicaState
    {
        public HiddenUputnicaState(EBolnicaContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }
        public override Model.Models.Uputnica Edit(int id)
        {
            var set = Context.Set<Database.Uputnica>();

            var entity = set.Find(id);

            entity.StateMachine = "draft";

            Context.SaveChanges();

            return Mapper.Map<Model.Models.Uputnica>(entity);
        }
        public override List<string> AllowedActions(Uputnica entity)
        {
            return new List<string>() { nameof(Edit) };
        }
    }
}
