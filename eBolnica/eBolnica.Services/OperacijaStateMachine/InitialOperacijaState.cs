using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Services;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.OperacijaStateMachine
{
    public class InitialOperacijaState : BaseOperacijaState
    {
        public InitialOperacijaState(Database.EBolnicaContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override Operacija Insert(OperacijaInsertRequest request)
        {
            var set = Context.Set<Database.Operacija>();
            var entity = Mapper.Map<Database.Operacija>(request);
            entity.StateMachine = "draft";
            set.Add(entity);
            Context.SaveChanges();
            return Mapper.Map<Operacija>(entity);
        }
        public override List<string> AllowedActions(Database.Operacija entity)
        {
            return new List<string>() { nameof(Insert) };
        }
    }
}
