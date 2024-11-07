using eBolnica.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.OperacijaStateMachine
{
    public class ClosedOperacijaState : BaseOperacijaState
    {
        public ClosedOperacijaState(EBolnicaContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }
        public override List<string> AllowedActions(Operacija entity)
        {
            return new List<string>() { };
        }
    }
}
