using eBolnica.Model;
using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
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

        [Authorize(Roles = "Administrator")]
        [HttpGet("broj-zaposlenih")]
        public IActionResult GetUkupanBrojZaposlenihPoOdjelima()
        {
            var result = odjelService.GetUkupanBrojZaposlenihPoOdjelima();
            return Ok(result);
        }

        [Authorize(Roles = "Administrator,Doktor,MedicinskoOsoblje,Pacijent")]
        public override PagedResult<Odjel> GetList([FromQuery] OdjelSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Administrator,Doktor,MedicinskoOsoblje,Pacijent")]
        public override Odjel GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Administrator")]
        public override Odjel Insert(OdjelInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Administrator")]
        public override Odjel Update(int id, OdjelUpdateRequest request)
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
