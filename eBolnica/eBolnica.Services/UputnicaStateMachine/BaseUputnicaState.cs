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

namespace eBolnica.Services.UputnicaStateMachine
{
    public class BaseUputnicaState
    {
        public EBolnicaContext Context { get; set; }
        public IMapper Mapper { get; }
        public IServiceProvider ServiceProvider { get; set; }
        public BaseUputnicaState(EBolnicaContext context, IMapper mapper, IServiceProvider serviceProvider)
        {
            Context = context;
            Mapper = mapper;
            ServiceProvider = serviceProvider;
        }
        public virtual Model.Models.Uputnica Insert(UputnicaInsertRequest request)
        {
            throw new UserException("Metoda nije dozvoljena");
        }
        public virtual Model.Models.Uputnica Update(int id, UputnicaUpdateRequest request)
        {
            throw new UserException("Metoda nije dozvoljena");
        }
        public virtual Model.Models.Uputnica Activate(int id)
        {
            throw new UserException("Metoda nije dozvoljena");
        }
        public virtual Model.Models.Uputnica Hide(int id)
        {
            throw new UserException("Metoda nije dozvoljena");
        }
        public virtual Model.Models.Uputnica Edit(int id)
        {
            throw new UserException("Metoda nije dozvoljena");
        }
        public virtual Model.Models.Uputnica Close(int id)
        {
            throw new UserException("Metoda nije dozvoljena");
        }
        public virtual List<string> AllowedActions(Database.Uputnica entity)
        {
            throw new UserException("Metoda nije dozvoljena");
        }
        public BaseUputnicaState CreateState(string stateName)
        {
            switch (stateName)
            {
                case "initial":
                    return ServiceProvider.GetService<InitialUputnicaState>();
                case "draft":
                    return ServiceProvider.GetService<DraftUputnicaState>();
                case "active":
                    return ServiceProvider.GetService<ActiveUputnicaState>();
                case "hidden":
                    return ServiceProvider.GetService<HiddenUputnicaState>();
                case "closed":
                    return ServiceProvider.GetService<ClosedUputnicaState>();
                default: throw new Exception("State not recognized");
            }
        }

    }
}
