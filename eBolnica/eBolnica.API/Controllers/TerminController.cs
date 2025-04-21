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
    public class TerminController : BaseCRUDController<Termin, TerminSearchObject, TerminInsertRequest, TerminUpdateRequest>
    {
        private readonly ITerminService _terminService;
        public TerminController(ITerminService service) : base(service)
        {
            _terminService = service;
        }

        [Authorize(Roles = "Pacijent,MedicinskoOsoblje")]
        [HttpGet("zauzeti-termini")]
        public ActionResult<List<string>> GetZauzetiTermini(DateTime datum, int doktorId)
        {
            var zauzetiTermini = _terminService.GetZauzetiTerminiZaDatum(datum, doktorId);
            return Ok(zauzetiTermini);
        }

        [Authorize(Roles = "Administrator,Doktor,Pacijent,MedicinskoOsoblje")]
        public override PagedResult<Termin> GetList([FromQuery] TerminSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Administrator,Doktor,Pacijent,MedicinskoOsoblje")]
        public override Termin GetById(int id)
        {
            return base.GetById(id);
        }
       
        [Authorize(Roles = "Pacijent,MedicinskoOsoblje")]
        public override Termin Insert(TerminInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Administrator,MedicinskoOsoblje")]
        public override Termin Update(int id, TerminUpdateRequest request)
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
