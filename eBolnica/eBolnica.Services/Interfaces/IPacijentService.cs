using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.Response;
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
        public List<Pacijent> GetPacijentWithDokumentacija();
        public List<Pacijent> GetPacijentiZaHospitalizaciju();
        public Task<List<PreglediResponse>> GetPreglediByPacijentIdAsync(int pacijentId);
        public Task<List<Database.Hospitalizacija>> GetHospitalizacijeByPacijentIdAsync(int pacijentId);
        public Task<List<Database.OtpusnoPismo>> GetOtpusnaPismaByPacijentIdAsync(int pacijentId);
        public Task<List<Database.Terapija>> GetTerapijaByPacijentIdAsync(int pacijentId);
        public Task<List<Database.LaboratorijskiNalaz>> GetNalaziByPacijentIdAsync(int pacijentId);
        public Task<List<Database.Operacija>> GetOperacijeByPacijentIdAsync(int pacijentId);
        public Task<List<Database.Terapija>> GetAktivneTerapijeByPacijentIdAsync(int pacijentId);
        public Task<List<Database.Terapija>> GetGotoveTerapijeByPacijentIdAsync(int pacijentId);
        public BrojPacijenataResponse GetBrojPacijenata();
        List<Model.Models.Doktor> GetPreporuceneDoktore(int pacijentId);
        public void TrainModel();

    }
}
