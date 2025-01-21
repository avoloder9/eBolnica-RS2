using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Identity.Client;

namespace eBolnica.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class OdjelController : BaseCRUDController<Odjel, OdjelSearchObject, OdjelInsertRequest, OdjelUpdateRequest>
    {
        public readonly IOdjelService odjelService;
        public OdjelController(IOdjelService service) : base(service)
        {
            odjelService = service;
        }
        [HttpGet("GetDoktorByOdjel")]
        public IActionResult GetDoktorByOdjel(int odjelId)
        {
            try
            {
                var doktori = odjelService.GetDoktorByOdjelId(odjelId);
                return Ok(doktori);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
