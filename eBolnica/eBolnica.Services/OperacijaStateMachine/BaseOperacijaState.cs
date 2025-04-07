using eBolnica.Model;
using eBolnica.Model.Requests;
using eBolnica.Services.Database;
using MapsterMapper;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.OperacijaStateMachine
{
    public class BaseOperacijaState
    {
        public EBolnicaContext Context { get; set; }
        public IMapper Mapper { get; }
        public IServiceProvider ServiceProvider { get; set; }
        public BaseOperacijaState(EBolnicaContext context, IMapper mapper, IServiceProvider serviceProvider)
        {
            Context = context;
            Mapper = mapper;
            ServiceProvider = serviceProvider;
        }
        public virtual Model.Models.Operacija Insert(OperacijaInsertRequest request)
        {
            throw new UserException("Metoda nije dozvoljena");
        }
        public virtual Model.Models.Operacija Update(int id, OperacijaUpdateRequest request)
        {
            throw new UserException("Metoda nije dozvoljena");
        }
        public virtual Model.Models.Operacija Activate(int id)
        {
            throw new UserException("Metoda nije dozvoljena");
        }
        public virtual Model.Models.Operacija Hide(int id)
        {
            throw new UserException("Metoda nije dozvoljena");
        }
        public virtual Model.Models.Operacija Edit(int id)
        {
            throw new UserException("Metoda nije dozvoljena");
        }
        public virtual Model.Models.Operacija Close(int id)
        {
            throw new UserException("Metoda nije dozvoljena");
        }
        public virtual Model.Models.Operacija Cancel(int id)
        {
            throw new UserException("Metoda nije dozvoljena");
        }
        public virtual List<string> AllowedActions(Database.Operacija entity)
        {
            throw new UserException("Metoda nije dozvoljena");
        }
        public BaseOperacijaState CreateState(string stateName)
        {
            switch (stateName)
            {
                case "initial":
                    return ServiceProvider.GetService<InitialOperacijaState>()!;
                case "draft":
                    return ServiceProvider.GetService<DraftOperacijaState>()!;
                case "active":
                    return ServiceProvider.GetService<ActiveOperacijaState>()!;
                case "hidden":
                    return ServiceProvider.GetService<HiddenOperacijaState>()!;
                case "closed":
                    return ServiceProvider.GetService<ClosedOperacijaState>()!;
                case "cancelled":
                    return ServiceProvider.GetService<CancelledOperacijaState>()!;
                default: throw new Exception("State not recognized");
            }
        }

    }
}
