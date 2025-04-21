using eBolnica.Model;
using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using eBolnica.Services.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
namespace eBolnica.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class NalazParametarController : BaseCRUDController<NalazParametar, NalazParametarSearchObject, NalazParametarInsertRequest, NalazParametarUpdateRequest>
    {
        public NalazParametarController(INalazParametarService service) : base(service) { }

        [Authorize(Roles = "Administrator,Doktor,Pacijent,MedicinskoOsoblje")]
        [HttpGet("GetNalazParametarValues")]
        public async Task<IActionResult> GetNalazParametarValues([FromQuery] NalazParametarSearchObject search)
        {
            var result = await (_service as INalazParametarService)!.GetNalazParametarValues(search);

            if (result == null || !result.Any())
            {
                return NotFound("No results found.");
            }

            return Ok(result);
        }
      
        [Authorize(Roles = "Administrator,Doktor,Pacijent,MedicinskoOsoblje")]
        public override PagedResult<NalazParametar> GetList([FromQuery] NalazParametarSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Administrator,Doktor,Pacijent,MedicinskoOsoblje")]
        public override NalazParametar GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "MedicinskoOsoblje")]
        public override NalazParametar Insert(NalazParametarInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "MedicinskoOsoblje")]
        public override NalazParametar Update(int id, NalazParametarUpdateRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "Administrator,MedicinskoOsoblje")]
        public override void Delete(int id)
        {
            base.Delete(id);
        }

    }
}
