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
using Microsoft.ML;
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
            var usedTerminIds = Context.Pregleds.Include(x => x.Uputnica).Where(p => p.Uputnica != null && p.Uputnica!.TerminId != null)
                .Select(p => p.Uputnica.TerminId);

            query = base.AddFilter(searchObject, query).Include(x => x.Doktor).ThenInclude(a => a.Korisnik).
                Include(y => y.Odjel).Include(z => z.Pacijent).ThenInclude(k => k.Korisnik)
                .Where(x => x.DatumTermina.Date >= DateTime.Today && x.Otkazano == false && !usedTerminIds.Contains(x.TerminId)).OrderBy(x => x.DatumTermina);
            if (searchObject!.DoktorId != null)
            {
                query = query.Where(x => x.Doktor.DoktorId == searchObject.DoktorId);
            }
            if (searchObject!.OdjelId != null)
            {
                query = query.Where(x => x.OdjelId == searchObject.OdjelId);
            }
            if (searchObject!.PacijentId != null)
            {
                query = query.Where(x => x.PacijentId == searchObject.PacijentId);
            }
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
                              p.Korisnik.Email,
                              p.Korisnik.Ime,
                              p.Korisnik.Prezime
                          })
                          .FirstOrDefault();

            if (pacijent == null || string.IsNullOrEmpty(pacijent.Email))
            {
                throw new Exception("E-mail pacijenta nije pronađen.");
            }
            var doktor = Context.Doktors
                        .Where(d => d.DoktorId == request.DoktorId).Include(x => x.Korisnik)
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
                Message = $"Poštovani, Vaš termin sa doktorom {doktor.Ime} {doktor.Prezime} je uspješno zakazan.<br/>" +
                  $"Datum: {entity.DatumTermina:dd.MM.yyyy}<br/>" +
                  $"Vrijeme: { entity.VrijemeTermina.ToString(@"hh\:mm\:ss")}<br/>"+
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
                return null!;
            }
            return Mapper.Map<Model.Models.Termin>(entity);
        }
        public override void BeforeUpdate(TerminUpdateRequest request, Database.Termin entity)
        {
            var termin = Context.Termins.Include(x => x.Pacijent).ThenInclude(x => x.Korisnik).Include(x => x.Doktor).ThenInclude(x => x.Korisnik).Include(x => x.Odjel).FirstOrDefault(x => x.TerminId == entity.TerminId);
            if (termin == null)
            {
                throw new Exception("Termin sa zadanim ID-om ne postoji.");
            }

            var pacijent = termin.Pacijent;
            if (pacijent == null || pacijent.Korisnik == null || string.IsNullOrEmpty(pacijent.Korisnik.Email))
            {
                throw new Exception("E-mail pacijenta nije pronađen.");
            }

            var doktor = termin.Doktor;
            if (doktor == null || doktor.Korisnik == null)
            {
                throw new Exception("Doktor sa zadanim ID-om nije pronađen.");
            }

            var odjel = termin.Odjel?.Naziv ?? "Nepoznat odjel";

            _rabbitMQService.SendEmail(new Model.Messages.Email
            {
                EmailTo = pacijent.Korisnik.Email,
                Subject = "Vaš termin je otkazan",
                Message = $"Poštovani, obavještavamo Vas da je Vaš termin sa doktorom {doktor.Korisnik.Ime} {doktor.Korisnik.Prezime} otkazan.<br>" +
               $"Molimo Vas da, ukoliko je potrebno, zakažete novi termin u skladu s Vašim potrebama.<br>" +
               $"Detalji otkazanog termina:<br>" +
               $"Doktor: {doktor.Korisnik.Ime} {doktor.Korisnik.Prezime}<br>" +
               $"Datum: {entity.DatumTermina:dd.MM.yyyy}<br>" +
               $"Odjel: {odjel}<br>" +
               $"Hvala Vam na razumijevanju.",
                ReceiverName = pacijent.Korisnik.Ime + " " + pacijent.Korisnik.Prezime,
            });

            base.BeforeUpdate(request, entity);
        }
        public List<string> GetZauzetiTerminiZaDatum(DateTime datum, int doktorId)
        {
            return Context.Termins.Where(x => x.DatumTermina.Date == datum.Date && (x.Otkazano == null || x.Otkazano == false) && x.DoktorId == doktorId).Select(x => x.VrijemeTermina.ToString(@"hh\:mm")).ToList();
        }
    }
}
