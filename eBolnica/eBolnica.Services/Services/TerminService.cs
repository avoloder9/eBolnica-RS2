using eBolnica.Model;
using eBolnica.Model.Messages;
using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Database;
using eBolnica.Services.Interfaces;
using eBolnica.Services.RabbitMQ;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace eBolnica.Services.Services
{
    public class TerminService : BaseCRUDService<Model.Models.Termin, TerminSearchObject, Database.Termin, TerminInsertRequest, TerminUpdateRequest>, ITerminService
    {
        private readonly IRabbitMQService _rabbitMQService;

        public TerminService(Database.EBolnicaContext context, IMapper mapper, IRabbitMQService rabbitMQService) : base(context, mapper)
        {
            _rabbitMQService = rabbitMQService;
        }

        public override IQueryable<Database.Termin> AddFilter(TerminSearchObject searchObject, IQueryable<Database.Termin> query)
        {
            query = base.AddFilter(searchObject, query).Include(x => x.Doktor).ThenInclude(a => a.Korisnik)
                .Include(y => y.Odjel).Include(z => z.Pacijent).ThenInclude(k => k.Korisnik).Where(x => x.DatumTermina >= DateTime.Now);

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
            var pacijent = Context.Pacijents
                          .Where(p => p.PacijentId == request.PacijentId)
                          .Select(p => new
                          {
                              p.Korisnik.Email, p.Korisnik.Ime,p.Korisnik.Prezime
                          })
                          .FirstOrDefault();

            if (pacijent == null || string.IsNullOrEmpty(pacijent.Email))
            {
                throw new Exception("E-mail pacijenta nije pronađen.");
            }
            var doktor = Context.Doktors
                        .Where(d => d.DoktorId == request.DoktorId).Include(x=> x.Korisnik)
                        .Select(d => new { d.Korisnik.Ime, d.Korisnik.Prezime })
                        .FirstOrDefault();

            if (doktor == null)
            {
                throw new Exception("Doktor sa zadanim ID-om nije pronađen.");
            }

            var odjel = Context.Odjels
                               .Where(o => o.OdjelId == request.OdjelId)
                               .Select(o => o.Naziv)
                               .FirstOrDefault();

            if (odjel == null)
            {
                throw new Exception("Odjel sa zadanim ID-om nije pronađen.");
            }
            var email = pacijent.Email;

            _rabbitMQService.SendEmail(new Model.Messages.Email
            {
                EmailTo = pacijent.Email,
                Subject = "Vaš termin je uspješno zakazan",
                Message = $"Poštovani, Vaš termin sa doktorom {doktor.Ime} {doktor.Prezime} je uspješno zakazan. Detalji:\n" +
                   $"Doktor: {doktor.Ime} {doktor.Prezime}\n" +
                   $"Datum: {entity.DatumTermina}\n" +
                   $"Odjel: {odjel}",
                ReceiverName = pacijent.Ime + " " + pacijent.Prezime,
            });

            base.BeforeInsert(request, entity);
        }
        public override Model.Models.Termin GetById(int id)
        {
            var entity = Context.Set<Database.Termin>().Include(x => x.Doktor).ThenInclude(a => a.Korisnik)
                .Include(y => y.Odjel).Include(z => z.Pacijent).ThenInclude(k => k.Korisnik).FirstOrDefault(x => x.TerminId == id);
            if (entity == null)
            {
                return null;
            }
            return Mapper.Map<Model.Models.Termin>(entity);
        }
        public List<string> GetZauzetiTerminiZaDatum(DateTime datum, int doktorId)
        {
            return Context.Termins.Where(x => x.DatumTermina.Date == datum.Date && (x.Otkazano == null || x.Otkazano == false) && x.DoktorId == doktorId).Select(x => x.VrijemeTermina.ToString(@"hh\:mm")).ToList();
        }
        public Task<Database.Uputnica?> GetUputnicaByTerminId(int terminId)
        {
            return Context.Uputnicas.FirstOrDefaultAsync(x => x.TerminId == terminId);
        }
    }
}
