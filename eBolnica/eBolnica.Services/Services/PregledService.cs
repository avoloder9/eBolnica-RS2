using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.Services
{
    public class PregledService : BaseCRUDService<Pregled, PregledSearchObject, Database.Pregled, PregledInsertRequest, PregledUpdateRequest>, IPregledService
    {
        public PregledService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Database.Pregled> AddFilter(PregledSearchObject searchObject, IQueryable<Database.Pregled> query)
        {
            query = base.AddFilter(searchObject, query).Include(x => x.Uputnica).ThenInclude(y => y.Termin).ThenInclude(t => t.Doktor).ThenInclude(d => d.Korisnik)
                .Include(x => x.Uputnica).ThenInclude(y => y.Termin).ThenInclude(t => t.Pacijent).ThenInclude(p => p.Korisnik);

            if (!string.IsNullOrWhiteSpace(searchObject?.ImeGTE))
            {
                query = query.Where(x => x.Uputnica.Termin.Pacijent.Korisnik.Ime.StartsWith(searchObject.ImeGTE));
            }
            if (!string.IsNullOrWhiteSpace(searchObject?.PrezimeGTE))
            {
                query = query.Where(x => x.Uputnica.Termin.Pacijent.Korisnik.Prezime.StartsWith(searchObject.PrezimeGTE));
            }
            return query;
        }
        public override void BeforeInsert(PregledInsertRequest request, Database.Pregled entity)
        {
            var uputnicaExists = Context.Uputnicas.Any(p => p.UputnicaId == request.UputnicaId);
            if (!uputnicaExists)
            {
                throw new Exception("Uputnica sa zadanim ID-om ne postoji");
            }

            base.BeforeInsert(request, entity);
        }
    }
}
