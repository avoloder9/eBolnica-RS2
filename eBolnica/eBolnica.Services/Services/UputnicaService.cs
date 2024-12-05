using Azure.Core;
using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using eBolnica.Services.UputnicaStateMachine;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.Services
{
    public class UputnicaService : BaseCRUDService<Uputnica, UputnicaSearchObject, Database.Uputnica, UputnicaInsertRequest, UputnicaUpdateRequest>, IUputnicaService
    {
        public BaseUputnicaState BaseUputnicaState { get; set; }
        ILogger<UputnicaService> _logger;
        public UputnicaService(Database.EBolnicaContext context, IMapper mapper, BaseUputnicaState baseUputnicaState, ILogger<UputnicaService> logger) : base(context, mapper)
        {
            BaseUputnicaState = baseUputnicaState;
            _logger = logger;
        }
        public override IQueryable<Database.Uputnica> AddFilter(UputnicaSearchObject searchObject, IQueryable<Database.Uputnica> query)
        {
            query = base.AddFilter(searchObject, query).Include(u => u.Termin).ThenInclude(t => t.Pacijent).ThenInclude(p => p.Korisnik)
                .Include(u => u.Termin).ThenInclude(t => t.Doktor).ThenInclude(d => d.Korisnik).Include(u => u.Termin.Odjel);

            if (!string.IsNullOrWhiteSpace(searchObject?.ImeGTE))
            {
                query = query.Where(x => x.Termin.Pacijent.Korisnik.Ime.StartsWith(searchObject.ImeGTE));
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.PrezimeGTE))
            {
                query = query.Where(x => x.Termin.Pacijent.Korisnik.Prezime.StartsWith(searchObject.PrezimeGTE));
            }

            if (searchObject?.BrojZdravstveneKartice != null && searchObject.BrojZdravstveneKartice > 0)
            {
                query = query.Where(x => x.Termin.Pacijent.BrojZdravstveneKartice == searchObject.BrojZdravstveneKartice);
            }
            return query;
        }
        public override void BeforeInsert(UputnicaInsertRequest request, Database.Uputnica entity)
        {
            var terminExists = Context.Uputnicas.Any(t => t.TerminId == request.TerminId);
            if (!terminExists)
            {
                throw new Exception("Termin sa zadanim ID-om ne postoji");
            }
        }

        public override Uputnica GetById(int id)
        {
            var entity = Context.Set<Database.Uputnica>().Include(u => u.Termin)
        .ThenInclude(t => t.Pacijent).ThenInclude(p => p.Korisnik).Include(u => u.Termin).ThenInclude(t => t.Doktor).ThenInclude(d => d.Korisnik)
    .Include(u => u.Termin.Odjel).FirstOrDefault(x => x.UputnicaId == id);
            if (entity == null)
            {
                return null;
            }
            return Mapper.Map<Uputnica>(entity);
        }
        public override Uputnica Insert(UputnicaInsertRequest request)
        {
            var state = BaseUputnicaState.CreateState("initial");
            return state.Insert(request);
        }
        public override Uputnica Update(int id, UputnicaUpdateRequest request)
        {
            var entity = GetById(id);
            var state = BaseUputnicaState.CreateState(entity.StateMachine);
            return state.Update(id, request);
        }

        public Uputnica Activate(int id)
        {
            var entity = GetById(id);
            var state = BaseUputnicaState.CreateState(entity.StateMachine);
            return state.Activate(id);
        }

        public Uputnica Hide(int id)
        {
            var entity = GetById(id);
            var state = BaseUputnicaState.CreateState(entity.StateMachine);
            return state.Hide(id);
        }

        public Uputnica Edit(int id)
        {
            var entity = GetById(id);
            var state = BaseUputnicaState.CreateState(entity.StateMachine);
            return state.Edit(id);
        }

        public List<string> AllowedActions(int id)
        {
            _logger.LogInformation($"Allowed actions called for: {id}");

            if (id <= 0)
            {
                var state = BaseUputnicaState.CreateState("initial");
                return state.AllowedActions(null);
            }
            else
            {
                var entity = Context.Uputnicas.Find(id);
                var state = BaseUputnicaState.CreateState(entity.StateMachine);
                return state.AllowedActions(entity);
            }
        }

        public Uputnica Close(int id)
        {
            var entity = GetById(id);
            var state = BaseUputnicaState.CreateState(entity.StateMachine);
            return state.Close(id);
        }
    }
}
