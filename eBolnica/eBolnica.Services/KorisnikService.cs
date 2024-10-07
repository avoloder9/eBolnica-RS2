using eBolnica.Model;
using eBolnica.Model.Requests;
using eBolnica.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services
{
    public class KorisnikService : IKorisnikService
    {
        public EBolnicaContext Context { get; set; }
        public IMapper Mapper { get; }

        public KorisnikService(EBolnicaContext context, IMapper mapper)
        {
            Context = context;
            Mapper = mapper;
        }

        public virtual List<Model.Korisnik> GetList()
        {
            List<Model.Korisnik> result = new List<Model.Korisnik>();
            var list = Context.Korisniks.ToList();
            result = Mapper.Map(list, result);
            return result;
        }

        public Model.Korisnik Insert(KorisnikInsertRequest request)
        {
            if (request.Lozinka != request.LozinkaPotvrda)
            {
                throw new Exception("Lozinka i LozinkaPotvrda moraju biti iste");
            }
            Database.Korisnik korisnik = new Database.Korisnik();
            Mapper.Map(request, korisnik);
            korisnik.LozinkaSalt = GenerateSalt();
            korisnik.LozinkaHash = GenerateHash(korisnik.LozinkaSalt, request.Lozinka);

            Context.Add(korisnik);
            Context.SaveChanges();

            return Mapper.Map<Model.Korisnik>(korisnik);
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
        public Model.Korisnik Update(int id, KorisnikUpdateRequest request)
        {
            var korisnik = Context.Korisniks.Find(id);
            Mapper.Map(request, korisnik);
            if (request.Lozinka != null)
            {
                if (request.Lozinka != request.LozinkaPotvrda)
                {
                    throw new Exception("Lozinka i LozinkaPotvrda moraju biti iste");
                }
                korisnik!.LozinkaSalt = GenerateSalt();
                korisnik.LozinkaHash = GenerateHash(korisnik.LozinkaSalt, request.Lozinka);
            }

            Context.SaveChanges();
            return Mapper.Map<Model.Korisnik>(korisnik!);
        }
    }
}
