using eBolnica.Model;
using eBolnica.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services
{
    public class KorisnikService : IKorisnikService
    {
        public EBolnicaContext Context { get; set; }
        public KorisnikService(EBolnicaContext context)
        {
            Context = context;
        }

        public List<Model.Korisnik> GetList()
        {
            var list = Context.Korisniks.ToList();
            var result = new List<Model.Korisnik>();
            list.ForEach(item =>
            {
                result.Add(new Model.Korisnik()
                {
                    KorisnikId = item.KorisnikId,
                    Ime = item.Ime,
                    Prezime = item.Prezime,
                });
            });
            return result;
        }
    }
}
