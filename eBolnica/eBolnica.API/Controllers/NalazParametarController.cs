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
    public class NalazParametarController : BaseCRUDController<NalazParametar, NalazParametarSearchObject, NalazParametarInsertRequest, NalazParametarUpdateRequest>
    {
        public NalazParametarController(INalazParametarService service) : base(service) { }

        [HttpGet("GetNalazParametarValues")]
        public async Task<IActionResult> GetNalazParametarValues([FromQuery] NalazParametarSearchObject search)
        {
            var result = await (_service as INalazParametarService).GetNalazParametarValues(search);

            if (result == null || !result.Any())
            {
                return NotFound("No results found.");
            }

            return Ok(result);
        }
    }
}
