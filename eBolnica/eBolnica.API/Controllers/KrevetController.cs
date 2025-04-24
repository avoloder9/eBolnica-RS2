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
    public class KrevetController : BaseCRUDController<Krevet, KrevetSearchObject, KrevetInsertRequest, KrevetUpdateRequest>
    {
        private readonly IKrevetService krevetService;
        public KrevetController(IKrevetService service) : base(service)
        {
            krevetService = service;
        }

        [Authorize(Roles = "Doktor")]
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

        [Authorize(Roles = "Administrator")]
        [HttpGet("popunjenost")]
        public IActionResult GetPopunjenostBolnice()
        {
            var result = krevetService.GetPopunjenostBolnice();
            return Ok(result);
        }

        [Authorize(Roles = "Administrator,MedicinskoOsoblje,Doktor")]
        public override PagedResult<Krevet> GetList([FromQuery] KrevetSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }
      
        [Authorize(Roles = "Administrator,MedicinskoOsoblje,Doktor")]
        public override Krevet GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Administrator")]
        public override Krevet Insert(KrevetInsertRequest request)
        {
            return base.Insert(request);
        }
       
        [Authorize(Roles = "Administrator")]
        public override Krevet Update(int id, KrevetUpdateRequest request)
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
