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
    public class LaboratorijskiNalazService : BaseCRUDService<LaboratorijskiNalaz, LaboratorijskiNalazSearchObject, Database.LaboratorijskiNalaz, LaboratorijskiNalazInsertRequest, LaboratorijskiNalazUpdateRequest>, ILaboratorijskiNalazService
    {
        public LaboratorijskiNalazService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Database.LaboratorijskiNalaz> AddFilter(LaboratorijskiNalazSearchObject searchObject, IQueryable<Database.LaboratorijskiNalaz> query)
        {
            query = base.AddFilter(searchObject, query).Include(p => p.Pacijent).ThenInclude(k => k.Korisnik).Include(x=>x.Doktor).ThenInclude(x=>x.Korisnik);

            if (!string.IsNullOrWhiteSpace(searchObject?.ImePacijentaGTE))
            {
                query = query.Where(x => x.Pacijent.Korisnik.Ime.StartsWith(searchObject.ImePacijentaGTE));
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.PrezimePacijentaGTE))
            {
                query = query.Where(x => x.Pacijent.Korisnik.Prezime.StartsWith(searchObject.PrezimePacijentaGTE));
            }
            return query;
        }
        public override void BeforeInsert(LaboratorijskiNalazInsertRequest request, Database.LaboratorijskiNalaz entity)
        {
            var pacijentExists = Context.Pacijents.Any(p => p.PacijentId == request.PacijentId);
            if (!pacijentExists)
            {
                throw new Exception("Pacijent sa zadanim ID-om ne postoji");
            }
            var doktorExists = Context.Doktors.Any(d => d.DoktorId == request.DoktorId);
            if (!doktorExists)
            {
                throw new Exception("Doktor sa zadanim ID-om ne postoji");
            }
            base.BeforeInsert(request, entity);
        }
    }
}
