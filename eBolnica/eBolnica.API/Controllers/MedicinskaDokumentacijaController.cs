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
    public class MedicinskaDokumentacijaController : BaseCRUDController<MedicinskaDokumentacija, MedicinskaDokumentacijaSearchObject, MedicinskaDokumentacijaInsertRequest, MedicinskaDokumentacijaUpdateRequest>
    {
        private readonly IMedicinskaDokumentacijaService _medicinskaDokumentacijaService;
        public MedicinskaDokumentacijaController(IMedicinskaDokumentacijaService service) : base(service) { _medicinskaDokumentacijaService = service; }
        [HttpGet("getMedicinskaDokumentacija/{pacijentId}")]
        public IActionResult GetByPacijentId(int pacijentId)
        {
            var dokumentacija = _medicinskaDokumentacijaService.GetByPacijentId(pacijentId);
            if (dokumentacija == null)
                return NotFound();

            return Ok(dokumentacija);
        }
    }
}
