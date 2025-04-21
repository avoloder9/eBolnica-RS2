using eBolnica.Model;
using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.Response;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using eBolnica.Services.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eBolnica.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class PacijentController : BaseCRUDController<Pacijent, PacijentSearchObject, PacijentInsertRequest, PacijentUpdateRequest>
    {
        private readonly IPacijentService _pacijentService;
        public PacijentController(IPacijentService service) : base(service)
        {
            _pacijentService = service;
        }

        [AllowAnonymous]
        [HttpPost("register")]
        public IActionResult Register([FromBody] PacijentInsertRequest request)
        {
            try
            {
                var pacijent = _pacijentService.Insert(request);
                return Ok(pacijent);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [AllowAnonymous]
        public override Pacijent Insert(PacijentInsertRequest request)
        {
            return base.Insert(request);
        }
        [Authorize(Roles = "Administrator,Pacijent,Doktor,MedicinskoOsoblje")]
        public override PagedResult<Pacijent> GetList([FromQuery] PacijentSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }
      
        [Authorize(Roles = "Administrator,Pacijent,Doktor,MedicinskoOsoblje")]
        public override Pacijent GetById(int id)
        {
            return base.GetById(id);
        }
     
        [Authorize(Roles = "Administrator,Pacijent")]
        public override Pacijent Update(int id, PacijentUpdateRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "Administrator")]
        public override void Delete(int id)
        {
            base.Delete(id);
        }

        [Authorize(Roles = "Administrator,Pacijent")]
        [HttpGet("GetPacijentIdByKorisnikId/{korisnikId}")]
        public IActionResult GetPacijentIdByKorisnikId(int korisnikId)
        {
            int pacijentId = _pacijentService.GetPacijentIdByKorisnikId(korisnikId);

            if (pacijentId != 0)
            {
                return Ok(pacijentId);
            }
            else
            {
                return NotFound();
            }
        }

        [Authorize(Roles = "Administrator,Doktor,MedicinskoOsoblje")]
        [HttpGet("GetPacijentSaDokumenticijom")]
        public ActionResult<List<Pacijent>> GetPacijentiSaMedicinskomDokumentacijom()
        {
            return Ok(_pacijentService.GetPacijentSaDokumentacija());
        }

        [Authorize(Roles = "Doktor")]
        [HttpGet("GetPacijentiZaHospitalizaciju")]
        public ActionResult<List<Pacijent>> GetPacijentiZaHospitalizaciju()
        {
            return Ok(_pacijentService.GetPacijentiZaHospitalizaciju());
        }

        [Authorize(Roles = "Administrator,Doktor,Pacijent,MedicinskoOsoblje")]
        [HttpGet("getPregledByPacijentId/{pacijentId}")]
        public async Task<IActionResult> GetPregledByPacijentId(int pacijentId)
        {
            var pacijent = await _pacijentService.GetPreglediByPacijentIdAsync(pacijentId);
            if (pacijent == null)
            {
                return NotFound(new { message = "Pregledi nisu pronadjeni" });
            }
            return Ok(pacijent);
        }

        [Authorize(Roles = "Pacijent")]
        [HttpGet("getAktivneTerapijeByPacijentId/{pacijentId}")]
        public async Task<IActionResult> GetAktivneTerapijeByPacijentId(int pacijentId)
        {
            var pacijent = await _pacijentService.GetAktivneTerapijeByPacijentIdAsync(pacijentId);
            if (pacijent == null)
            {
                return NotFound(new { message = "Terapije nisu pronadjene" });
            }
            return Ok(pacijent);
        }

        [Authorize(Roles = "Pacijent")]
        [HttpGet("getGotoveTerapijeByPacijentId/{pacijentId}")]
        public async Task<IActionResult> GetGotoveTerapijeByPacijentId(int pacijentId)
        {
            var pacijent = await _pacijentService.GetGotoveTerapijeByPacijentIdAsync(pacijentId);
            if (pacijent == null)
            {
                return NotFound(new { message = "Terapije nisu pronadjene" });
            }
            return Ok(pacijent);
        }

        [Authorize(Roles = "Administrator")]
        [HttpGet("broj-pacijenata")]
        public IActionResult GetBrojPacijenata()
        {
            var result = _pacijentService.GetBrojPacijenata();
            return Ok(result);
        }

        [AllowAnonymous]
        [HttpGet("{pacijentId}/recommended-doktori")]
        public ActionResult<List<Model.Models.Doktor>> GetRecommendedDoktori(int pacijentId)
        {
            var recommended = _pacijentService.GetPreporuceneDoktore(pacijentId);
            return Ok(recommended);
        }

        [AllowAnonymous]
        [HttpGet("train-model")]
        public void TrainModel()
        {
            _pacijentService.TrainModel();
        }

    }
}
