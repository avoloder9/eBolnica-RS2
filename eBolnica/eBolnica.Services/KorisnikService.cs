using eBolnica.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services
{
    public class KorisnikService : IKorisnikService
    {
        public List<Korisnik> List = new List<Korisnik>()
        {
            new Korisnik()
            {
                KorisnikId= 1,
                Ime="Adnan",
                Prezime="Voloder"
            },
            new Korisnik()
            {
                KorisnikId= 2,
                Ime="Denis",
                Prezime="Music"
            }
        };
        public List<Korisnik> GetList()
        {
            return List;
        }
    }
}
