using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using MapsterMapper;
using Microsoft.Identity.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using eBolnica.Services.Helpers;
using Microsoft.EntityFrameworkCore;
using eBolnica.Services.Interfaces;
using eBolnica.Model.Models;

namespace eBolnica.Services.Services
{
    public class PacijentService : BaseCRUDService<Pacijent, PacijentSearchObject, Database.Pacijent, PacijentInsertRequest, PacijentUpdateRequest>, IPacijentService
    {
        public PacijentService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        { }

        public override void BeforeInsert(PacijentInsertRequest request, Database.Pacijent entity)
        {
            if (request.Lozinka != request.LozinkaPotvrda)
            {
                throw new Exception("Lozinka i LozinkaPotvrda moraju biti iste");
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
            entity.Adresa = request.Adresa;
            entity.BrojZdravstveneKartice = request.BrojZdravstveneKartice;
            entity.Dob = request.Dob;

            base.BeforeInsert(request, entity);
        }

        public override IQueryable<Database.Pacijent> AddFilter(PacijentSearchObject searchObject, IQueryable<Database.Pacijent> query)
        {
            query = base.AddFilter(searchObject, query);
            query = query.Include(x => x.Korisnik);

            if (!string.IsNullOrWhiteSpace(searchObject?.ImeGTE))
            {
                query = query.Where(x => x.Korisnik.Ime.StartsWith(searchObject.ImeGTE));
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.PrezimeGTE))
            {
                query = query.Where(x => x.Korisnik.Prezime.StartsWith(searchObject.PrezimeGTE));
            }

            if (searchObject?.BrojZdravstveneKartice != null && searchObject.BrojZdravstveneKartice > 0)
            {
                query = query.Where(x => x.BrojZdravstveneKartice == searchObject.BrojZdravstveneKartice);
            }
            return query;
        }
        public override Pacijent GetById(int id)
        {
            var entity = Context.Set<Database.Pacijent>().Include(x => x.Korisnik).FirstOrDefault(a => a.PacijentId == id);
            if (entity == null)
            {
                return null;
            }
            return Mapper.Map<Pacijent>(entity);
        }
        public override void BeforeUpdate(PacijentUpdateRequest request, Database.Pacijent entity)
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
    }
}
