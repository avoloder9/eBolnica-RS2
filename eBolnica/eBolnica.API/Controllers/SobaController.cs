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
    public class SobaController : BaseCRUDController<Soba, SobaSearchObject, SobaInsertRequest, SobaUpdateRequest>
    {
        public readonly ISobaService sobaService;
        public SobaController(ISobaService service) : base(service) {
            sobaService = service;
        }

        [HttpGet("GetSobaByOdjelId")]
        public IActionResult GetSobaByOdjelId(int odjelId)
        {
            try
            {
                var sobe = sobaService.GetSobaByOdjelId(odjelId);
                return Ok(sobe);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
        [HttpGet("GetSlobodnaSobaByOdjelId")]
        public IActionResult GetSlobodnaSobaByOdjelId(int odjelId)
        {
            try
            {
                var sobe = sobaService.GetSlobodneSobaByOdjelId(odjelId);
                return Ok(sobe);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
