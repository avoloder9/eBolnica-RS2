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
    public class PregledController : BaseCRUDController<Pregled, PregledSearchObject, PregledInsertRequest, PregledUpdateRequest>
    {
        private readonly IPregledService _pregledService;
        public PregledController(IPregledService service) : base(service) { _pregledService = service; }
        [HttpGet("broj-pregleda")]
        public IActionResult GetBrojPregledaPoDanu([FromQuery] int brojDana)
        {
            var result = _pregledService.GetBrojPregledaPoDanu(brojDana);
            return Ok(result);
        }
    }
}
