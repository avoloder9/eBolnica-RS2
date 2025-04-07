using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.Response;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Database;
using eBolnica.Services.Interfaces;
using eBolnica.Services.RabbitMQ;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.Services
{
    public class NalazParametarService : BaseCRUDService<Model.Models.NalazParametar, NalazParametarSearchObject, Database.NalazParametar, NalazParametarInsertRequest, NalazParametarUpdateRequest>, INalazParametarService
    {
        private readonly IRabbitMQService _rabbitMQService;

        public NalazParametarService(Database.EBolnicaContext context, IMapper mapper, IRabbitMQService rabbitMQService) : base(context, mapper)
        {
            _rabbitMQService = rabbitMQService;
        }
        public override IQueryable<Database.NalazParametar> AddFilter(NalazParametarSearchObject searchObject, IQueryable<Database.NalazParametar> query)
        {
            query = query.Include(x => x.LaboratorijskiNalaz)
                   .ThenInclude(y => y.Pacijent)
                   .ThenInclude(z => z.Korisnik)
                   .Include(p => p.Parametar);

            if (!string.IsNullOrWhiteSpace(searchObject.ImePacijenta))
            {
                query = query.Where(x => x.LaboratorijskiNalaz.Pacijent.Korisnik.Ime.Contains(searchObject.ImePacijenta));
            }

            if (!string.IsNullOrWhiteSpace(searchObject.PrezimePacijenta))
            {
                query = query.Where(x => x.LaboratorijskiNalaz.Pacijent.Korisnik.Prezime.Contains(searchObject.PrezimePacijenta));
            }
            if (searchObject?.LaboratorijskiNalazId != null && searchObject.LaboratorijskiNalazId > 0)
            {
                query = query.Where(x => x.LaboratorijskiNalazId == searchObject.LaboratorijskiNalazId);
            }
            return base.AddFilter(searchObject!, query);
        }

        public override void BeforeInsert(NalazParametarInsertRequest request, Database.NalazParametar entity)
        {
            var nalaz = Context.LaboratorijskiNalazs.Include(x => x.Doktor).ThenInclude(x => x.Korisnik).Include(x => x.Pacijent).ThenInclude(x => x.Korisnik)
                .FirstOrDefault(n => n.LaboratorijskiNalazId == request.LaboratorijskiNalazId);
            if (nalaz == null)
            {
                throw new Exception("Laboratorijski nalaz sa zadanim ID-om ne postoji");
            }
            var parametarExists = Context.Parametars.Any(p => p.ParametarId == request.ParametarId);
            if (!parametarExists)
            {
                throw new Exception("Parametar sa zadanim ID-om ne postoji");
            }
            if (nalaz.Doktor == null || nalaz.Doktor.Korisnik == null)
            {
                throw new Exception("Doktor nije pronadjen za ovaj nalaz");
            }
            var hospitalizacija = Context.Hospitalizacijas.Include(h => h.Odjel).FirstOrDefault(h => h.PacijentId == nalaz.PacijentId && h.DatumOtpusta == null);

            if (hospitalizacija == null || hospitalizacija.OdjelId != nalaz.Doktor.OdjelId)
            {
                base.BeforeInsert(request, entity);
                return;
            }
            _rabbitMQService.SendEmail(new Model.Messages.Email
            {
                EmailTo = nalaz.Doktor.Korisnik.Email,
                Subject = "Novi laboratorijski nalaz",
                Message = $"Poštovani {nalaz.Doktor.Korisnik.Ime} {nalaz.Doktor.Korisnik.Prezime},\n\n" +
                               $"Obavještavamo Vas da je kreiran novi laboratorijski nalaz.\n\n" +
                               $"Pacijent:{nalaz.Pacijent.Korisnik.Ime} {nalaz.Pacijent.Korisnik.Prezime} \n" +
                               $"Datum nalaza: {nalaz.DatumNalaza}\n" +
                               $"Srdačan pozdrav,\nVaša eBolnica",
                ReceiverName = nalaz.Doktor.Korisnik.Ime + " " + nalaz.Doktor.Korisnik.Prezime,
            });
            base.BeforeInsert(request, entity);
        }
        public Task<List<Model.Models.NalazParametar>> GetNalazParametarValues(NalazParametarSearchObject search)
        {
            var query = Context.NalazParametars.AsQueryable();
            query = AddFilter(search, query);
            if (search.HospitalizacijaId.HasValue)
            {
                query = query.Include(x => x.LaboratorijskiNalaz).ThenInclude(x => x.Pacijent).ThenInclude(x => x.Hospitalizacijas)
                    .Where(x => x.LaboratorijskiNalaz.Pacijent.Hospitalizacijas.Any(h => h.HospitalizacijaId == search.HospitalizacijaId
                && x.LaboratorijskiNalaz.DatumNalaza.Date >= h.DatumPrijema.Date &&
                (h.DatumOtpusta == null || x.LaboratorijskiNalaz.DatumNalaza.Date <= h.DatumOtpusta)));
            }

            return query.Select(x => new Model.Models.NalazParametar
            {
                Parametar = new Model.Models.Parametar
                {
                    Naziv = x.Parametar.Naziv,
                    MaxVrijednost = x.Parametar.MaxVrijednost,
                    MinVrijednost = x.Parametar.MinVrijednost,

                },
                Vrijednost = x.Vrijednost,
                LaboratorijskiNalazId = x.LaboratorijskiNalazId,
                NalazParametarId = x.NalazParametarId


            }).ToListAsync();
        }
    }
}
