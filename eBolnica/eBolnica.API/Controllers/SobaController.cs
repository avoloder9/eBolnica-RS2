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
    public class SobaController : BaseCRUDController<Soba, SobaSearchObject, SobaInsertRequest, SobaUpdateRequest>
    {
        public readonly ISobaService sobaService;
        public SobaController(ISobaService service) : base(service)
        {
            sobaService = service;
        }
        [Authorize(Roles = "Administrator,Doktor,MedicinskoOsoblje")]
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

        [Authorize(Roles = "Administrator,Doktor,MedicinskoOsoblje")]
        public override PagedResult<Soba> GetList([FromQuery] SobaSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Administrator,Doktor,MedicinskoOsoblje")]
        public override Soba GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Administrator")]
        public override Soba Insert(SobaInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Administrator")]
        public override Soba Update(int id, SobaUpdateRequest request)
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
