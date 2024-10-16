using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services
{
    public class AdministratorService : BaseCRUDService<Model.Administrator, AdministratorSearchObject, Database.Administrator, AdministratorInsertRequest, AdministratorUpdateRequest>, IAdministratorService
    {
        public AdministratorService(EBolnicaContext context, IMapper mapper) : base(context, mapper)
        { }

        public Model.Administrator InsertAdministratorWithUserDetails(AdministratorInsertRequest request)
        {
            string salt = GenerateSalt();
            string hash = GenerateHash(salt, request.Lozinka);
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
                LozinkaSalt = salt
            };

            Context.Korisniks.Add(korisnik);
            Context.SaveChanges();

            Database.Administrator administrator = new Database.Administrator
            {
                Korisnik = korisnik,
                KorisnikId = korisnik.KorisnikId
            };

            Context.Administrators.Add(administrator);
            Context.SaveChanges();
            return Mapper.Map<Model.Administrator>(administrator);
        }

        public static string GenerateSalt()
        {
            var byteArray = RNGCryptoServiceProvider.GetBytes(16);
            return Convert.ToBase64String(byteArray);
        }
        public static string GenerateHash(string salt, string password)
        {
            byte[] src = Convert.FromBase64String(salt);
            byte[] bytes = Encoding.Unicode.GetBytes(password);
            byte[] dst = new byte[src.Length + bytes.Length];

            System.Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            System.Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

            HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
            byte[] inArray = algorithm!.ComputeHash(dst);
            return Convert.ToBase64String(inArray);
        }
       
        public override IQueryable<Database.Administrator> AddFilter(AdministratorSearchObject searchObject, IQueryable<Database.Administrator> query)
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

            if (!string.IsNullOrWhiteSpace(searchObject?.Email))
            {
                query = query.Where(x => x.Korisnik.Email == searchObject.Email);
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.KorisnickoIme))
            {
                query = query.Where(x => x.Korisnik.KorisnickoIme == searchObject.KorisnickoIme);
            }

            return query;
        }

        public override void BeforeUpdate(AdministratorUpdateRequest request, Administrator entity)
        {
            base.BeforeUpdate(request, entity);
            var korisnik = Context.Korisniks.Find(entity.KorisnikId);
            if (korisnik != null)
            {
                Mapper.Map(request, korisnik);
            }
        }

        public override Model.Administrator GetById(int id)
        {
            var entity = Context.Set<Database.Administrator>().Include(x => x.Korisnik).FirstOrDefault(a => a.AdministratorId == id);
            if (entity == null)
            {
                return null;
            }
            return Mapper.Map<Model.Administrator>(entity);
        }

    }
}
