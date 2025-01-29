using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

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
        [HttpGet("zauzeti-termini")]
        public ActionResult<List<string>> GetZauzetiTermini(DateTime datum, int doktorId)
        {
            var zauzetiTermini = _terminService.GetZauzetiTerminiZaDatum(datum,doktorId);
            return Ok(zauzetiTermini);
        }
    }
}
