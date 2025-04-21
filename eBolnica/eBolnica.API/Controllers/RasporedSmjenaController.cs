using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using eBolnica.Services.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using eBolnica.Model;

namespace eBolnica.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class RasporedSmjenaController : BaseCRUDController<RasporedSmjena, RasporedSmjenaSearchObject, RasporedSmjenaInsertRequest, RasporedSmjenaUpdateRequest>
    {
        private readonly IRasporedSmjenaService rasporedSmjenaService;
        public RasporedSmjenaController(IRasporedSmjenaService service) : base(service) { rasporedSmjenaService = service; }

        [Authorize(Roles = "Administrator")]
        [HttpPost("generisi-raspored")]
        public async Task<IActionResult> GenerisiRaspored(DateTime startDate, DateTime endDate)
        {
            try
            {
                await rasporedSmjenaService.GenerisiRasporedSmjena(startDate, endDate);
                return Ok("Raspored smjena uspješno generisan.");
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [Authorize(Roles = "Administrator,MedicinskoOsoblje")]
        public override PagedResult<RasporedSmjena> GetList([FromQuery] RasporedSmjenaSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Administrator,MedicinskoOsoblje")]
        public override RasporedSmjena GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Administrator")]
        public override RasporedSmjena Insert(RasporedSmjenaInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Administrator")]
        public override RasporedSmjena Update(int id, RasporedSmjenaUpdateRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "Administrator")]
        public override void Delete(int id)
        {
            base.Delete(id);
        }

    }
}
