using eBolnica.Model;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services
{
    public interface IKorisnikService
    {
        PagedResult<Korisnik> GetList(KorisnikSearchObject searchObject);
        Korisnik Insert(KorisnikInsertRequest request);
        Korisnik Update(int id, KorisnikUpdateRequest request);
    }
}
