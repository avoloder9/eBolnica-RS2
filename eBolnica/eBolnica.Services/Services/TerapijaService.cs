using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
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
    public class TerapijaService : BaseCRUDService<Terapija, TerapijaSearchObject, Database.Terapija, TerapijaInsertRequest, TerapijaUpdateRequest>, ITerapijaService
    {
        private readonly IRabbitMQService _rabbitMQService;
        public TerapijaService(Database.EBolnicaContext context, IMapper mapper, IRabbitMQService rabbitMQService) : base(context, mapper)
        {
            _rabbitMQService = rabbitMQService;
        }
        public override void BeforeInsert(TerapijaInsertRequest request, Database.Terapija entity)
        {
            if (request.PregledId.HasValue)
            {
                var pregled = Context.Pregleds.Include(p => p.Uputnica).ThenInclude(x => x.Termin).ThenInclude(t => t.Pacijent).ThenInclude(p => p.Korisnik)
                    .FirstOrDefault(p => p.PregledId == request.PregledId);

                if (pregled == null)
                {
                    throw new Exception("Pregled sa zadanim ID-om ne postoji");
                }

                var pacijent = pregled.Uputnica.Termin?.Pacijent;
                if (pacijent == null || pacijent.Korisnik == null || string.IsNullOrEmpty(pacijent.Korisnik.Email))
                {
                    throw new Exception("E-mail pacijenta nije pronađen.");
                }

                _rabbitMQService.SendEmail(new Model.Messages.Email
                {
                    EmailTo = pacijent.Korisnik.Email,
                    Subject = "Nova terapija dodijeljena",
                    Message = $"Poštovani {pacijent.Korisnik.Ime} {pacijent.Korisnik.Prezime},\n\n" +
                              $"Obavještavamo Vas da Vam je dodijeljena nova terapija.\n\n" +
                              $"Naziv terapije: {request.Naziv}\n" +
                              $"Opis: {request.Opis}\n" +
                              $"Početak terapije: {request.DatumPocetka:dd.MM.yyyy}\n" +
                              $"Završetak terapije: {request.DatumZavrsetka:dd.MM.yyyy}\n\n" +
                              $"Molimo Vas da se pridržavate preporučenih uputa.\n\n" +
                              $"Srdačan pozdrav,\nVaša eBolnica",
                    ReceiverName = pacijent.Korisnik.Ime + " " + pacijent.Korisnik.Prezime,
                });
            }

            base.BeforeInsert(request, entity);
        }
        public Database.Terapija? GetTerapijaByPregledId(int pregledId)
        {
            return Context.Terapijas.FirstOrDefault(t => t.PregledId == pregledId);
        }
    }

}
