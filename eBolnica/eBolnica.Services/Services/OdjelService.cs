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
    public class OdjelService : BaseCRUDService<Odjel, OdjelSearchObject, Database.Odjel, OdjelInsertRequest, OdjelUpdateRequest>, IOdjelService
    {
        public OdjelService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Database.Odjel> AddFilter(OdjelSearchObject searchObject, IQueryable<Database.Odjel> query)
        {
            query = base.AddFilter(searchObject, query).Include(x => x.Bolnica).Include(y=>y.GlavniDoktor).ThenInclude(k=>k!=null ? k.Korisnik:null);


            if (!string.IsNullOrWhiteSpace(searchObject?.NazivGTE))
            {
                query = query.Where(x => x.Naziv.StartsWith(searchObject.NazivGTE));
            }
            return query;
        }
        public override void BeforeInsert(OdjelInsertRequest request, Database.Odjel entity)
        {
            var bolnica = Context.Bolnicas.FirstOrDefault(b => b.BolnicaId == entity.BolnicaId);
            if (bolnica == null)
            {
                throw new Exception("Bolnica sa zadanim ID-om ne postoji");
            }
            if (bolnica.UkupanBrojOdjela == null)
            {
                bolnica.UkupanBrojOdjela = 0;
            }
            bolnica.UkupanBrojOdjela++;
            Context.SaveChanges();
            base.BeforeInsert(request, entity);
        }
        public override void BeforeUpdate(OdjelUpdateRequest request, Database.Odjel entity)
        {

            if (request.GlavniDoktorId != 0)
            {
                var doktorExists = Context.Set<Database.Doktor>().Any(d => d.DoktorId == request.GlavniDoktorId);
                if (!doktorExists)
                {
                    throw new Exception("Glavni doktor s tim Id-om ne postoji");
                }
                entity.GlavniDoktorId = request.GlavniDoktorId;
            }
            else
            {
                entity.GlavniDoktorId = null;
            }
        }
        public List<Model.Models.Doktor> GetDoktorByOdjelId(int odjelId)
        {
            var doktoriDatabase = Context.Set<Database.Doktor>()
                                         .Where(x => x.OdjelId == odjelId).Include(x => x.Korisnik)
                                         .ToList();

            if (doktoriDatabase.Count == 0)
            {
                throw new Exception("Nema doktora na ovom odjelu");
            }

            var doktoriModel = doktoriDatabase.Select(d => new Model.Models.Doktor
            {
                DoktorId = d.DoktorId,
                Korisnik = new Model.Models.Korisnik
                {
                    Ime = d.Korisnik.Ime,
                    Prezime = d.Korisnik.Prezime,
                    Email = d.Korisnik.Email,
                    KorisnickoIme = d.Korisnik.KorisnickoIme,
                    DatumRodjenja = d.Korisnik.DatumRodjenja,
                    KorisnikId = d.Korisnik.KorisnikId,
                    Spol = d.Korisnik.Spol,
                    Status = d.Korisnik.Status,
                    Telefon = d.Korisnik.Telefon
                },
                Specijalizacija = d.Specijalizacija,
                KorisnikId = d.KorisnikId,
                Biografija = d.Biografija,
                OdjelId = d.OdjelId
            }).ToList();
            return doktoriModel;
        }
    }
}

