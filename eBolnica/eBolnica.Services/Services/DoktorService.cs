using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Helpers;
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
    public class DoktorService : BaseCRUDService<Doktor, DoktorSearchObject, Database.Doktor, DoktorInsertRequest, DoktorUpdateRequest>, IDoktorService
    {
        public DoktorService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override void BeforeInsert(DoktorInsertRequest request, Database.Doktor entity)
        {
            if (request.Lozinka != request.LozinkaPotvrda)
            {
                throw new Exception("Lozinka i LozinkaPotvrda moraju biti iste");
            }
            var odjelExists = Context.Set<Database.Odjel>().Any(d => d.OdjelId == request.OdjelId);
            if (!odjelExists)
            {
                throw new Exception("Odjel s tim Id-om ne postoji");
            }
            string salt = HashGenerator.GenerateSalt();
            string hash = HashGenerator.GenerateHash(salt, request.Lozinka);
            var korisnik = new Database.Korisnik
            {
                Ime = request.Ime,
                Prezime = request.Prezime,
                KorisnickoIme = request.KorisnickoIme,
                DatumRodjenja = request.DatumRodjenja,
                Email = request.Email,
                Spol = request.Spol,
                Telefon = request.Telefon,
                Status = request.Status,
                Slika = request.Slika,
                SlikaThumb = request.SlikaThumb,
                LozinkaHash = hash,
                LozinkaSalt = salt,
            };

            Context.Korisniks.Add(korisnik);
            Context.SaveChanges();
            entity.Korisnik = korisnik;
            entity.KorisnikId = korisnik.KorisnikId;
            entity.Biografija = request.Biografija;
            entity.Specijalizacija = request.Specijalizacija;
            entity.OdjelId = request.OdjelId;
            base.BeforeInsert(request, entity);
        }
        public override IQueryable<Database.Doktor> AddFilter(DoktorSearchObject searchObject, IQueryable<Database.Doktor> query)
        {
            query = base.AddFilter(searchObject, query).Include(x => x.Korisnik).Include(y=>y.Odjel);

            if (!string.IsNullOrWhiteSpace(searchObject?.ImeGTE))
            {
                query = query.Where(x => x.Korisnik.Ime.StartsWith(searchObject.ImeGTE));
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.PrezimeGTE))
            {
                query = query.Where(x => x.Korisnik.Prezime.StartsWith(searchObject.PrezimeGTE));
            }

            return query;
        }

        public override Doktor GetById(int id)
        {
            var entity = Context.Set<Database.Doktor>().Include(x => x.Korisnik).Include(x=>x.Odjel).FirstOrDefault(a => a.DoktorId == id);
            if (entity == null)
            {
                return null;
            }
            return Mapper.Map<Doktor>(entity);
        }
        public override void BeforeUpdate(DoktorUpdateRequest request, Database.Doktor entity)
        {
            if (request.Lozinka != request.LozinkaPotvrda)
            {
                throw new Exception("Lozinka i LozinkaPotvrda moraju biti iste");
            }
            base.BeforeUpdate(request, entity);
            var korisnik = Context.Korisniks.Find(entity.KorisnikId);
            if (korisnik != null)
            {
                Mapper.Map(request, korisnik);
            }
        }
        public int GetDoktorIdByKorisnikId(int korisnikId)
        {
            var admin = Context.Doktors.FirstOrDefault(t => t.KorisnikId == korisnikId);
            return admin.DoktorId;
        }
    }
}
