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
    public class UputnicaService : BaseCRUDService<Uputnica, UputnicaSearchObject, Database.Uputnica, UputnicaInsertRequest, UputnicaUpdateRequest>, IUputnicaService
    {
        public UputnicaService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
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
            var statusExists = Context.Statuses.Any(s => s.StatusId == request.StatusId);
            if (!statusExists)
            {
                throw new Exception("Status sa zadanim ID-om ne postoji");
            }
            var terminExists = Context.Uputnicas.Any(t => t.TerminId == request.TerminId);
            if (!statusExists)
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
    }
}
