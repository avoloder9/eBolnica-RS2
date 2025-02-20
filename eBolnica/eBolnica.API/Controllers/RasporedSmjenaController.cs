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
    public class RasporedSmjenaController : BaseCRUDController<RasporedSmjena, RasporedSmjenaSearchObject, RasporedSmjenaInsertRequest, RasporedSmjenaUpdateRequest>
    {
        private readonly IRasporedSmjenaService rasporedSmjenaService;
        public RasporedSmjenaController(IRasporedSmjenaService service) : base(service) { rasporedSmjenaService = service; }

        [HttpPost("generisi-raspored")]
        public async Task<IActionResult> GenerisiRaspored()
        {
            try
            {
                await rasporedSmjenaService.GenerisiRasporedSmjena();
                return Ok("Raspored smjena uspješno generisan.");
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

    }
}
