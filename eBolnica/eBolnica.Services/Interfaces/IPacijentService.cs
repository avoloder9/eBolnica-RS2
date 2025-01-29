using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.Interfaces
{
    public interface IPacijentService : ICRUDService<Pacijent, PacijentSearchObject, PacijentInsertRequest, PacijentUpdateRequest>
    {
        public List<Model.Models.Termin> GetTerminByPacijentId(int pacijentId);
        public int GetPacijentIdByKorisnikId(int korisnikId);

    }
}
