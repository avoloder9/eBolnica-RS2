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

    }
}
