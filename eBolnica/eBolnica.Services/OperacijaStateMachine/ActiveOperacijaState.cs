using eBolnica.Services.Database;
using eBolnica.Services.OperacijaStateMachine;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.OperacijaStateMachine
{
    public class ActiveOperacijaState : BaseOperacijaState
    {
        public ActiveOperacijaState(EBolnicaContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }
        public override Model.Models.Operacija Hide(int id)
        {
            var set = Context.Set<Database.Operacija>();
            var entity = set.Find(id);
            entity!.StateMachine = "hidden";
            Context.SaveChanges();
            return Mapper.Map<Model.Models.Operacija>(entity);
        }
        public override Model.Models.Operacija Close(int id)
        {
            var set = Context.Set<Database.Operacija>();
            var entity = set.Find(id);
            entity!.StateMachine = "closed";
            Context.SaveChanges();
            return Mapper.Map<Model.Models.Operacija>(entity);
        }
        public override List<string> AllowedActions(Operacija entity)
        {
            return new List<string>() { nameof(Hide), nameof(Close) };
        }
    }
}
