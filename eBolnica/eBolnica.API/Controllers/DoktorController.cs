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
    }
}
