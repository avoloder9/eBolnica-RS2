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
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.Services
{
    public class SlobodniDanService : BaseCRUDService<Model.Models.SlobodniDan, SlobodniDanSearchObject, Database.SlobodniDan, SlobodniDanInsertRequest, SlobodniDanUpdateRequest>, ISlobodniDanService
    {
        private readonly IRabbitMQService _rabbitMQService;
        public SlobodniDanService(Database.EBolnicaContext context, IMapper mapper, IRabbitMQService rabbitMQService) : base(context, mapper)
        {
            _rabbitMQService = rabbitMQService;
        }
        public override IQueryable<Database.SlobodniDan> AddFilter(SlobodniDanSearchObject searchObject, IQueryable<Database.SlobodniDan> query)
        {
            query = base.AddFilter(searchObject, query).Include(x => x.Korisnik);

            if (!string.IsNullOrWhiteSpace(searchObject?.ImeGTE))
            {
                query = query.Where(x => x.Korisnik.Ime.StartsWith(searchObject.ImeGTE));
            }
            if (!string.IsNullOrWhiteSpace(searchObject?.PrezimeGTE))
            {
                query = query.Where(x => x.Korisnik.Prezime.StartsWith(searchObject.PrezimeGTE));
            }
            if (searchObject.Status.HasValue)
            {
                query = query.Where(x => x.Status == searchObject.Status);
            }
            else
            {
                query = query.Where(x => x.Status == null);
            }
            return query;
        }
        public override void BeforeInsert(SlobodniDanInsertRequest request, Database.SlobodniDan entity)
        {
            var isDoktor = Context.Doktors.Any(p => p.KorisnikId == request.KorisnikId);
            var isMedicinskoOsoblje = Context.MedicinskoOsobljes.Any(m => m.KorisnikId == request.KorisnikId);

            if (!isDoktor && !isMedicinskoOsoblje)
            {
                throw new Exception("Korisnik mora biti doktor ili medicinsko osoblje da bi mu se mogao dodjeliti slobodan dan.");
            }
            base.BeforeInsert(request, entity);
        }
        public override void BeforeUpdate(SlobodniDanUpdateRequest request, Database.SlobodniDan entity)
        {
            var korisnik = Context.Korisniks.FirstOrDefault(x => x.KorisnikId == entity.KorisnikId);
            if (korisnik == null)
            {
                throw new Exception("Greška: Nema povezanog korisnika za ovaj zahtjev za slobodan dan.");
            }
            string statusPoruka = request.Status ? "odobren" : "odbijen";
            _rabbitMQService.SendEmail(new Model.Messages.Email
            {
                EmailTo = korisnik.Email,
                Subject = $"Zahtjev za slobodan dan - {statusPoruka.ToUpper()}",
                Message = $"Poštovani {korisnik.Ime} {korisnik.Prezime},\n\n" +
                     $"Vaš zahtjev za slobodan dan ({entity.Datum:dd.MM.yyyy}) je {statusPoruka}.\n\n" +
                     $"Srdačan pozdrav,\nVaša eBolnica",
                ReceiverName = korisnik.Ime + " " + korisnik.Prezime,
            });
            base.BeforeUpdate(request, entity);
        }
    }
}
