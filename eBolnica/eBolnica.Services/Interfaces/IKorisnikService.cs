using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.Interfaces
{
    public interface IKorisnikService : ICRUDService<Korisnik, KorisnikSearchObject, KorisnikInsertRequest, KorisnikUpdateRequest>
    {
        public Task<AuthenticationResponse> AuthenticateUser(string username, string password);
        public bool isKorisnikDoktor(int userId);
        public bool isKorisnikAdministrator(int userId);
        public bool isKorisnikMedicinskoOsoblje(int userId);
        public bool isKorisnikPacijent(int userId);
        bool PostojiEmail(string email);
        bool KorisnickoImePostoji(string korisnickoIme);

    }
}
