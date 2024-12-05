using eBolnica.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.UputnicaStateMachine
{
    public class ClosedUputnicaState : BaseUputnicaState
    {
        public ClosedUputnicaState(EBolnicaContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }
        public override List<string> AllowedActions(Uputnica entity)
        {
            return new List<string>() { };
        }
    }
}
