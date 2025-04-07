using Azure.Core;
using eBolnica.Model.Requests;
using eBolnica.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.OperacijaStateMachine
{
    public class DraftOperacijaState : BaseOperacijaState
    {
        public DraftOperacijaState(EBolnicaContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }
        public override Model.Models.Operacija Update(int id, OperacijaUpdateRequest request)
        {
            var set = Context.Set<Database.Operacija>();
            var entity = set.Find(id);
            Mapper.Map(request, entity);
            Context.SaveChanges();
            return Mapper.Map<Model.Models.Operacija>(entity!);
        }
        public override Model.Models.Operacija Activate(int id)
        {
            var set = Context.Set<Database.Operacija>();
            var entity = set.Find(id);
            entity!.StateMachine = "active";
            Context.SaveChanges();
            return Mapper.Map<Model.Models.Operacija>(entity);
        }
        public override Model.Models.Operacija Hide(int id)
        {
            var set = Context.Set<Database.Operacija>();
            var entity = set.Find(id);
            entity!.StateMachine = "hidden";
            Context.SaveChanges();
            return Mapper.Map<Model.Models.Operacija>(entity);
        }
        public override Model.Models.Operacija Cancel(int id)
        {
            var set = Context.Set<Database.Operacija>();
            var entity = set.Find(id);
            entity!.StateMachine = "cancelled";
            Context.SaveChanges();
            return Mapper.Map<Model.Models.Operacija>(entity);
        }
        public override List<string> AllowedActions(Operacija entity)
        {
            return new List<string>() { nameof(Activate), nameof(Update), nameof(Hide), nameof(Cancel) };
        }
    }
}
