
using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Database;
using eBolnica.Services.Interfaces;
using Mapster;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.Services
{
    public class OperacijaService : BaseCRUDService<Model.Models.Operacija, OperacijaSearchObject, Database.Operacija, OperacijaInsertRequest, OperacijaUpdateRequest>, IOperacijaService
    {
        public OperacijaService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Database.Operacija> AddFilter(OperacijaSearchObject searchObject, IQueryable<Database.Operacija> query)
        {
            query = base.AddFilter(searchObject, query).Include(d => d.Doktor).ThenInclude(k => k.Korisnik)
                .Include(p => p.Pacijent).ThenInclude(y => y.Korisnik).Include(t => t.Terapija);

            if (!string.IsNullOrWhiteSpace(searchObject?.ImePacijentaGTE))
            {
                query = query.Where(x => x.Pacijent.Korisnik.Ime.StartsWith(searchObject.ImePacijentaGTE));
            }
            if (!string.IsNullOrWhiteSpace(searchObject?.PrezimePacijentaGTE))
            {
                query = query.Where(x => x.Pacijent.Korisnik.Prezime.StartsWith(searchObject.PrezimePacijentaGTE));
            }
            if (!string.IsNullOrWhiteSpace(searchObject?.ImeDoktoraGTE))
            {
                query = query.Where(x => x.Doktor.Korisnik.Ime.StartsWith(searchObject.ImeDoktoraGTE));
            }
            if (!string.IsNullOrWhiteSpace(searchObject?.PrezimeDoktoraGTE))
            {
                query = query.Where(x => x.Doktor.Korisnik.Prezime.StartsWith(searchObject.PrezimeDoktoraGTE));
            }
            return query;
        }
        public override void BeforeInsert(OperacijaInsertRequest request, Database.Operacija entity)
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
            var terapijaExists = Context.Terapijas.Any(t => t.TerapijaId == request.TerapijaId);
            if (!terapijaExists)
            {
                throw new Exception("Terapija sa zadanim ID-om ne postoji");
            }
            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(OperacijaUpdateRequest request, Database.Operacija entity)
        {
            var doktorExists = Context.Doktors.Any(d => d.DoktorId == request.DoktorId);
            if (!doktorExists)
            {
                throw new Exception("Doktor sa zadanim ID-om ne postoji");
            }

            request.Adapt(entity);
            base.BeforeUpdate(request, entity);
        }
        public List<Model.Models.Operacija> GetOperacijaByPacijentId(int pacijentId)
        {
            var operacija = Context.Set<Database.Operacija>().Where(x => x.PacijentId == pacijentId).ToList();
            return Mapper.Map<List<Model.Models.Operacija>>(operacija);
        }
    }
}
