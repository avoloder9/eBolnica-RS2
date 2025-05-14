using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.Response;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using eBolnica.Services.UputnicaStateMachine;
using Mapster;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.Services
{
    public class PregledService : BaseCRUDService<Pregled, PregledSearchObject, Database.Pregled, PregledInsertRequest, PregledUpdateRequest>, IPregledService
    {
        public IServiceProvider ServiceProvider { get; set; }
        public PregledService(Database.EBolnicaContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper)
        {
            ServiceProvider = serviceProvider;
        }
        public override IQueryable<Database.Pregled> AddFilter(PregledSearchObject searchObject, IQueryable<Database.Pregled> query)
        {
            query = base.AddFilter(searchObject, query).Include(x => x.Uputnica).ThenInclude(y => y.Termin).ThenInclude(o => o.Odjel)
                .Include(x => x.Uputnica).ThenInclude(y => y.Termin).ThenInclude(t => t.Doktor).ThenInclude(d => d.Korisnik)
                .Include(x => x.Uputnica).ThenInclude(y => y.Termin).ThenInclude(t => t.Pacijent).ThenInclude(p => p.Korisnik).OrderByDescending(x=>x.Uputnica.Termin.DatumTermina);
            if (!string.IsNullOrWhiteSpace(searchObject?.PacijentImeGTE))
            {
                query = query.Where(x => x.Uputnica.Termin.Pacijent.Korisnik.Ime.StartsWith(searchObject.PacijentImeGTE));
            }
            if (!string.IsNullOrWhiteSpace(searchObject?.PacijentImeGTE))
            {
                query = query.Where(x => x.Uputnica.Termin.Pacijent.Korisnik.Prezime.StartsWith(searchObject.PacijentImeGTE));
            }
            if (!string.IsNullOrWhiteSpace(searchObject?.DoktorImeGTE))
            {
                query = query.Where(x => x.Uputnica.Termin.Doktor.Korisnik.Ime.StartsWith(searchObject.DoktorImeGTE));
            }
            if (!string.IsNullOrWhiteSpace(searchObject?.DoktorPrezimeGTE))
            {
                query = query.Where(x => x.Uputnica.Termin.Doktor.Korisnik.Prezime.StartsWith(searchObject.DoktorPrezimeGTE));
            }
            if (!string.IsNullOrWhiteSpace(searchObject?.NazivOdjela))
            {
                query = query.Where(x => x.Uputnica.Termin.Odjel.Naziv.Equals(searchObject.NazivOdjela));
            }
            if (searchObject!.DoktorId != null || searchObject.DoktorId > 0)
            {
                query = query.Where(x => x.Uputnica.Termin.Doktor.DoktorId == searchObject.DoktorId);
            }
            return query;
        }
        public override void BeforeInsert(PregledInsertRequest request, Database.Pregled entity)
        {
            var uputnica = Context.Uputnicas.Where(p => p.UputnicaId == request.UputnicaId).Select(p => new { p.StateMachine, p.Termin.DatumTermina }).FirstOrDefault();

            if (uputnica == null)
            {
                throw new Exception("Uputnica sa zadanim ID-om ne postoji");
            }

            if (uputnica.StateMachine != "active")
            {
                throw new Exception("Uputnica nije aktivna i nije moguce izvršiti pregled");
            }

            if (uputnica.DatumTermina.Date != DateTime.Now.Date)
            {
                throw new Exception("Pregled se može obaviti samo za termine zakazane na današnji dan");
            }

            var medicinskaDokumentacijaExists = Context.MedicinskaDokumentacijas.Any(p => p.MedicinskaDokumentacijaId == request.MedicinskaDokumentacijaId);
            if (!medicinskaDokumentacijaExists)
            {
                throw new Exception("Medicinska dokumentacija sa zadanim ID-om ne postoji");
            }
            base.BeforeInsert(request, entity);

            var baseUputnicaState = new BaseUputnicaState(Context, Mapper, ServiceProvider);
            var state = baseUputnicaState.CreateState(uputnica.StateMachine);
            state.Close(request.UputnicaId);
        }
        public List<Model.Response.BrojPregledaPoDanuResponse> GetBrojPregledaPoDanu(int brojDana)
        {
            DateTime endDate = DateTime.Now;
            DateTime startDate = endDate.AddDays(-brojDana);

            return Context.Pregleds
                .Where(p => p.Uputnica.Termin.DatumTermina >= startDate && p.Uputnica.Termin.DatumTermina <= endDate)
                .GroupBy(p => p.Uputnica.Termin.DatumTermina.Date)
                .Select(g => new BrojPregledaPoDanuResponse
                {
                    Datum = g.Key,
                    BrojPregleda = g.Count()
                })
                .OrderBy(x => x.Datum)
                .ToList();
        }

    }
}
