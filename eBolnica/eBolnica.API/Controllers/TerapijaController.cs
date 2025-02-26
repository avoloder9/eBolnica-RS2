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
    public class TerapijaController : BaseCRUDController<Terapija, TerapijaSearchObject, TerapijaInsertRequest, TerapijaUpdateRequest>
    {
        private readonly ITerapijaService terapijaService;
        public TerapijaController(ITerapijaService service) : base(service) { terapijaService = service; }


        [HttpGet("getTerapijabyPregledId/{pregledId}")]
        public IActionResult GetTerapijaByPregledId(int pregledId)
        {
            var terapija = terapijaService.GetTerapijaByPregledId(pregledId);
            if (terapija == null)
            {
                return NotFound();
            }
            return Ok(terapija);

        }
    }
}