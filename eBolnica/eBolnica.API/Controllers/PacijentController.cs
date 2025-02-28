using eBolnica.Model.Models;
using eBolnica.Model.Requests;
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

        [HttpGet("GetTerminByPacijent")]
        public IActionResult GetTerminByPacijent(int pacijentId)
        {
            try
            {
                var termini = _pacijentService.GetTerminByPacijentId(pacijentId);
                return Ok(termini);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
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

        [HttpGet("GetPacijentSaDokumenticijom")]
        public ActionResult<List<Pacijent>> GetPacijentiSaMedicinskomDokumentacijom()
        {
            return Ok(_pacijentService.GetPacijentWithDokumentacija());
        }

        [HttpGet("GetPacijentiZaHospitalizaciju")]
        public ActionResult<List<Pacijent>> GetPacijentiZaHospitalizaciju()
        {
            return Ok(_pacijentService.GetPacijentiZaHospitalizaciju());
        }
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
        [HttpGet("getHospitalizacijeByPacijentId/{pacijentId}")]
        public async Task<IActionResult> GetHospitalizacijeByPacijentId(int pacijentId)
        {
            var pacijent = await _pacijentService.GetHospitalizacijeByPacijentIdAsync(pacijentId);
            if (pacijent == null)
            {
                return NotFound(new { message = "Hospitlaizacije nisu pronadjene" });
            }
            return Ok(pacijent);
        }
        [HttpGet("getOtpusnaPismaByPacijentId/{pacijentId}")]
        public async Task<IActionResult> GetOtpusnaPismaByPacijentId(int pacijentId)
        {
            var pacijent = await _pacijentService.GetOtpusnaPismaByPacijentIdAsync(pacijentId);
            if (pacijent == null)
            {
                return NotFound(new { message = "Otpusna pisma nisu pronadjena" });
            }
            return Ok(pacijent);
        }
        [HttpGet("getTerapijaByPacijentId/{pacijentId}")]
        public async Task<IActionResult> GetTerapijaByPacijentId(int pacijentId)
        {
            var pacijent = await _pacijentService.GetTerapijaByPacijentIdAsync(pacijentId);
            if (pacijent == null)
            {
                return NotFound(new { message = "Terapije nisu pronadjene" });
            }
            return Ok(pacijent);
        }
        [HttpGet("getNalaziByPacijentId/{pacijentId}")]
        public async Task<IActionResult> GetNalaziByPacijentId(int pacijentId)
        {
            var pacijent = await _pacijentService.GetNalaziByPacijentIdAsync(pacijentId);
            if (pacijent == null)
            {
                return NotFound(new { message = "Nalazi nisu pronadjeni" });
            }
            return Ok(pacijent);
        }
        [HttpGet("getOperacijeByPacijentId/{pacijentId}")]
        public async Task<IActionResult> GetOperacijeByPacijentId(int pacijentId)
        {
            var pacijent = await _pacijentService.GetOperacijeByPacijentIdAsync(pacijentId);
            if (pacijent == null)
            {
                return NotFound(new { message = "Operacije nisu pronadjene" });
            }
            return Ok(pacijent);
        }
    }
}
