using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using eBolnica.Services.Helpers;
using eBolnica.Services.Interfaces;
using Microsoft.Extensions.Logging;

namespace eBolnica.Services.Services
{
    public class KorisnikService : BaseCRUDService<Model.Models.Korisnik, KorisnikSearchObject, Database.Korisnik, KorisnikInsertRequest, KorisnikUpdateRequest>, IKorisnikService
    {
        ILogger<KorisnikService> _logger;
        public KorisnikService(EBolnicaContext context, IMapper mapper, ILogger<KorisnikService> logger) : base(context, mapper)
        {
            _logger = logger;
        }

        public override IQueryable<Database.Korisnik> AddFilter(KorisnikSearchObject searchObject, IQueryable<Database.Korisnik> query)
        {
            query = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject?.ImeGTE))
            {
                query = query.Where(x => x.Ime.StartsWith(searchObject.ImeGTE));
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.PrezimeGTE))
            {
                query = query.Where(x => x.Prezime.StartsWith(searchObject.PrezimeGTE));
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.Email))
            {
                query = query.Where(x => x.Email == searchObject.Email);
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.KorisnickoIme))
            {
                query = query.Where(x => x.KorisnickoIme == searchObject.KorisnickoIme);
            }

            return query;
        }
        public override void BeforeInsert(KorisnikInsertRequest request, Database.Korisnik entity)
        {
            _logger.LogInformation($"Adding user: {entity.KorisnickoIme}");
            if (request.Lozinka != request.LozinkaPotvrda)
            {
                throw new Exception("Lozinka i LozinkaPotvrda moraju biti iste");
            }
            entity.LozinkaSalt = HashGenerator.GenerateSalt();
            entity.LozinkaHash = HashGenerator.GenerateHash(entity.LozinkaSalt, request.Lozinka);

            base.BeforeInsert(request, entity);
        }


        public override void BeforeUpdate(KorisnikUpdateRequest request, Database.Korisnik entity)
        {
            base.BeforeUpdate(request, entity);
            if (request.Lozinka != null)
            {
                if (request.Lozinka != request.LozinkaPotvrda)
                {
                    throw new Exception("Lozinka i LozinkaPotvrda moraju biti iste");
                }
                entity!.LozinkaSalt = HashGenerator.GenerateSalt();
                entity.LozinkaHash = HashGenerator.GenerateHash(entity.LozinkaSalt, request.Lozinka);
            }
        }

        public Model.Models.Korisnik Login(string username, string password)
        {
            var entity = Context.Korisniks.FirstOrDefault(x => x.KorisnickoIme == username);
            if (entity == null)
            {
                return null;
            }
            var hash = HashGenerator.GenerateHash(entity.LozinkaSalt, password);
            if (hash != entity.LozinkaHash)
            {
                return null;
            }

            return Mapper.Map<Model.Models.Korisnik>(entity);
        }
    }
}
