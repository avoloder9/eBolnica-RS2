using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using eBolnica.Services.Services;
using Microsoft.AspNetCore.Mvc;

namespace eBolnica.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class DoktorController : BaseCRUDController<Doktor, DoktorSearchObject, DoktorInsertRequest, DoktorUpdateRequest>
    {
        private readonly IDoktorService _doktorService;
        public DoktorController(IDoktorService service) : base(service)
        {
            _doktorService = service;
        }
        [HttpGet("GetDoktorIdByKorisnikId/{korisnikId}")]
        public IActionResult GetDoktorIdByKorisnikId(int korisnikId)
        {
            int doktorId = _doktorService.GetDoktorIdByKorisnikId(korisnikId);

            if (doktorId != 0)
            {
                return Ok(doktorId);
            }
            else
            {
                return NotFound();
            }
        }

        [HttpGet("GetTerminByDoktorId/{doktorId}")]
        public IActionResult GetTerminByDoktorId(int doktorId)
        {
            try
            {
                var termini = _doktorService.GetTerminByDoktorId(doktorId);
                return Ok(termini);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet("GetPregledByDoktorId/{doktorId}")]
        public IActionResult GetPregledByDoktorId(int doktorId)
        {
            try
            {
                var pregledi = _doktorService.GetPreglediByDoktorId(doktorId);
                return Ok(pregledi);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet("GetOperacijeByDoktorId/{doktorId}")]
        public IActionResult GetOperacijeByDoktorId(int doktorId)
        {
            try
            {
                var operacije = _doktorService.GetOperacijaByDoktorId(doktorId);
                return Ok(operacije);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
        [HttpGet("GetDnevniRaspored/{doktorId}")]
        public async Task<IActionResult> GetDnevniRaspored(int doktorId)
        {
            var raspored = await _doktorService.GetDnevniRasporedAsync(doktorId);
            return Ok(raspored);
        }
    }
}
