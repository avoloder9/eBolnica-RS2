using eBolnica.Model;
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
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace eBolnica.Services.Services
{
    public class TerminService : BaseCRUDService<Termin, TerminSearchObject, Database.Termin, TerminInsertRequest, TerminUpdateRequest>, ITerminService
    {
        public TerminService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Termin> AddFilter(TerminSearchObject searchObject, IQueryable<Database.Termin> query)
        {
            query = base.AddFilter(searchObject, query).Include(x => x.Doktor).ThenInclude(a => a.Korisnik).Include(y => y.Odjel).Include(z => z.Pacijent).ThenInclude(k => k.Korisnik);

            return base.AddFilter(searchObject, query);
        }

        public override void BeforeInsert(TerminInsertRequest request, Database.Termin entity)
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
            var odjelExists = Context.Odjels.Any(o => o.OdjelId == request.OdjelId);
            if (!odjelExists)
            {
                throw new Exception("Odjel sa zadanim ID-om ne postoji");
            }
            base.BeforeInsert(request, entity);
        }
        public override Termin GetById(int id)
        {
            var entity = Context.Set<Database.Termin>().Include(x => x.Doktor).ThenInclude(a => a.Korisnik)
                .Include(y => y.Odjel).Include(z => z.Pacijent).ThenInclude(k => k.Korisnik).FirstOrDefault(x => x.TerminId == id);
            if (entity == null)
            {
                return null;
            }
            return Mapper.Map<Termin>(entity);
        }
        public List<string> GetZauzetiTerminiZaDatum(DateTime datum, int doktorId)
        {
            return Context.Termins.Where(x => x.DatumTermina.Date == datum.Date && (x.Otkazano == null || x.Otkazano == false) && x.DoktorId==doktorId).Select(x => x.VrijemeTermina.ToString(@"hh\:mm")).ToList();
        }
    }
}
