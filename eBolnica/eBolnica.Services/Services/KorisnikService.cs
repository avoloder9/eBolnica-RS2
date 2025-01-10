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
using Microsoft.EntityFrameworkCore;

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

            var pw = ValidationHelper.CheckPasswordStrength(request.Lozinka);
            if (!string.IsNullOrEmpty(pw))
            {
                throw new Exception("Lozinka nije validna");
            }
            if (!string.IsNullOrEmpty(request.Telefon))
            {
                var phoneNumber = ValidationHelper.CheckPhoneNumber(request.Telefon);
                if (!string.IsNullOrEmpty(phoneNumber))
                {
                    throw new Exception("Broj telefona nije validan");
                }
            }

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
            if (!string.IsNullOrEmpty(request.Lozinka))
            {
                var pw = ValidationHelper.CheckPasswordStrength(request.Lozinka);
                if (!string.IsNullOrEmpty(pw))
                {
                    throw new Exception("Lozinka nije validna");
                }
            }
            if (!string.IsNullOrEmpty(request.Telefon))
            {
                var phoneNumber = ValidationHelper.CheckPhoneNumber(request.Telefon);
                if (!string.IsNullOrEmpty(phoneNumber))
                {
                    throw new Exception("Broj telefona nije validan");
                }
            }
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

        public async Task<AuthenticationResponse> AuthenticateUser(string username, string password)
        {
            var user = Context.Korisniks.FirstOrDefault(u => u.KorisnickoIme == username);

            if (user == null)
            {
                return new AuthenticationResponse { Result = AuthenticationResult.UserNotFound };
            }

            string hashedPassword = HashGenerator.GenerateHash(user.LozinkaSalt, password);

            if (hashedPassword != user.LozinkaHash)
            {
                return new AuthenticationResponse { Result = AuthenticationResult.InvalidPassword };
            }

            return new AuthenticationResponse { Result = AuthenticationResult.Success, UserId = user.KorisnikId};
        }

        public bool isKorisnikDoktor(int korisnikId)
        {
            var user=Context.Doktors.Any(x=>x.KorisnikId== korisnikId);
            return user;
        }
        public bool isKorisnikAdministrator(int korisnikId)
        {
            var user = Context.Administrators.Any(x => x.KorisnikId == korisnikId);
            return user;
        }
        public bool isKorisnikMedicinskoOsoblje(int korisnikId)
        {
            var user = Context.MedicinskoOsobljes.Any(x => x.KorisnikId == korisnikId);
            return user;
        }
        public bool isKorisnikPacijent(int korisnikId)
        {
            var user = Context.Pacijents.Any(x => x.KorisnikId == korisnikId);
            return user;
        }

    }
}
