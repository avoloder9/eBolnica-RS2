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
    public class VitalniParemetriService : BaseCRUDService<VitalniParametri, VitalniParametriSearchObject, Database.VitalniParametri, VitalniParametriInsertRequest, VitalniParametriUpdateRequest>, IVitalniParametriService
    {
        public VitalniParemetriService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Database.VitalniParametri> AddFilter(VitalniParametriSearchObject searchObject, IQueryable<Database.VitalniParametri> query)
        {
            query = base.AddFilter(searchObject, query).Include(x => x.Pacijent).ThenInclude(y => y.Korisnik);

            if (!string.IsNullOrWhiteSpace(searchObject?.ImeGTE))
            {
                query = query.Where(x => x.Pacijent.Korisnik.Ime.StartsWith(searchObject.ImeGTE));
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.PrezimeGTE))
            {
                query = query.Where(x => x.Pacijent.Korisnik.Prezime.StartsWith(searchObject.PrezimeGTE));
            }

            return query;
        }
        public override void BeforeInsert(VitalniParametriInsertRequest request, Database.VitalniParametri entity)
        {
            var pacijentExists = Context.Pacijents.Any(p => p.PacijentId == request.PacijentId);
            if (!pacijentExists)
            {
                throw new Exception("Pacijent sa zadanim ID-om ne postoji");
            }
            base.BeforeInsert(request, entity);
        }
        public override VitalniParametri GetById(int id)
        {
            var entity = Context.Set<Database.VitalniParametri>().Include(x => x.Pacijent).ThenInclude(y => y.Korisnik).FirstOrDefault(a => a.PacijentId == id);
            if (entity == null)
            {
                return null;
            }
            return Mapper.Map<VitalniParametri>(entity);
        }
    }
}
