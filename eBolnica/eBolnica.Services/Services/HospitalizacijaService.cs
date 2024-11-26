using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using Mapster;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.Services
{
    public class HospitalizacijaService : BaseCRUDService<Hospitalizacija, HospitalizacijaSearchObject, Database.Hospitalizacija, HospitalizacijaInsertRequest, HospitalizacijaUpdateRequest>, IHospitalizacijaService
    {
        public HospitalizacijaService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Database.Hospitalizacija> AddFilter(HospitalizacijaSearchObject searchObject, IQueryable<Database.Hospitalizacija> query)
        {
            query = base.AddFilter(searchObject, query).Include(x => x.Pacijent).ThenInclude(k => k.Korisnik).Include(d => d.Doktor).ThenInclude(a => a.Korisnik)
                .Include(o => o.Odjel).Include(a => a.Soba).Include(b => b.Krevet);

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
        public override void BeforeInsert(HospitalizacijaInsertRequest request, Database.Hospitalizacija entity)
        {
            var pacijentExists = Context.Pacijents.Any(p => p.PacijentId == request.PacijentId);
            if (!pacijentExists)
            {
                throw new Exception("Pacijent sa zadanim ID-om ne postoji");
            }
            var doktorExists = Context.Doktors.Any(d => d.DoktorId == request.DoktorId && d.OdjelId == request.OdjelId);
            if (!doktorExists)
            {
                throw new Exception("Doktor sa zadanim ID-om ne postoji ili ne radi na zadatom odjelu");
            }
            var odjelExists = Context.Odjels.Any(o => o.OdjelId == request.OdjelId);
            if (!odjelExists)
            {
                throw new Exception("Odjel sa zadanim ID-om ne postoji");
            }
            var sobaExists = Context.Sobas.Any(s => s.SobaId == request.SobaId && s.OdjelId == request.OdjelId);
            if (!sobaExists)
            {
                throw new Exception("Soba sa zadanim ID-om ne postoji ili ne pripada zadanom odjelu");
            }
            var krevetExists = Context.Krevets.Any(k => k.KrevetId == request.KrevetId && k.SobaId == request.SobaId);
            if (!krevetExists)
            {
                throw new Exception("Krevet sa zadanim ID-om ne postoji ili ne pripada zadanoj sobi");
            }
            var medicinskaDokumentacijaExists = Context.MedicinskaDokumentacijas.Any(k => k.MedicinskaDokumentacijaId == request.MedicinskaDokumentacijaId);
            if (!medicinskaDokumentacijaExists)
            {
                throw new Exception("Medicinska dokumentacija sa zadanim ID-om ne postoji ili ne pripada zadanoj sobi");
            }

            var bolnica = Context.Bolnicas.FirstOrDefault();

            var medicinskaDokumentacija = Context.MedicinskaDokumentacijas.FirstOrDefault(x => x.PacijentId == request.PacijentId);
            if (medicinskaDokumentacija != null)
            {
                medicinskaDokumentacija.Hospitalizovan = true;
                bolnica.TrenutniBrojHospitalizovanih++;
                Context.SaveChanges();
            }
            else
            {
                throw new Exception("Medicinska dokumentacija za zadatog pacijenta ne postoji");
            }
            base.BeforeInsert(request, entity);
        }
        public override void BeforeUpdate(HospitalizacijaUpdateRequest request, Database.Hospitalizacija entity)
        {
            var sobaExists = Context.Sobas.Any(s => s.SobaId == request.SobaId);
            if (!sobaExists)
            {
                throw new Exception("Soba sa zadanim ID-om ne postoji");
            }
            var krevetExists = Context.Krevets.Any(k => k.KrevetId == request.KrevetId && k.SobaId == request.SobaId);
            if (!krevetExists)
            {
                throw new Exception("Krevet sa zadanim ID-om ne postoji ili ne pripada zadanoj sobi");
            }
            request.Adapt(entity);
            base.BeforeUpdate(request, entity);
        }
    }
}
