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
    public class KrevetController : BaseCRUDController<Krevet, KrevetSearchObject, KrevetInsertRequest, KrevetUpdateRequest>
    {
        private readonly IKrevetService krevetService;
        public KrevetController(IKrevetService service) : base(service)
        {

            krevetService = service;
        }

        [HttpGet("GetSlobodanKrevetBySobaId")]
        public IActionResult GetSlobodanKrevetBySobaId(int sobaId)
        {
            try
            {
                var kreveti = krevetService.GetSlobodanKrevetBySobaId(sobaId);
                return Ok(kreveti);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet("popunjenost")]
        public IActionResult GetPopunjenostBolnice()
        {
            var result = krevetService.GetPopunjenostBolnice();
            return Ok(result);
        }
    }
}
