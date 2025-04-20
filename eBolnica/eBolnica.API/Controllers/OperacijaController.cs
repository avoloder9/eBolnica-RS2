using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using eBolnica.Services.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eBolnica.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class OperacijaController : BaseCRUDController<Operacija, OperacijaSearchObject, OperacijaInsertRequest, OperacijaUpdateRequest>
    {
        private readonly IOperacijaService _operacijaService;
        public OperacijaController(IOperacijaService service) : base(service) { _operacijaService = service; }
      
        [HttpPut("{id}/activate")]
        public Operacija Activate(int id)
        {
            return (_service as IOperacijaService)!.Activate(id);
        }
        [HttpPut("{id}/update")]
        public Operacija Update(int id, OperacijaUpdateRequest request)
        {
            return (_service as IOperacijaService)!.Update(id, request);
        }
        [HttpPut("{id}/edit")]
        public Operacija Edit(int id)
        {
            return (_service as IOperacijaService)!.Edit(id);
        }

        [HttpPut("{id}/hide")]
        public Operacija Hide(int id)
        {
            return (_service as IOperacijaService)!.Hide(id);
        }
        [HttpPut("{id}/close")]
        public Operacija Close(int id)
        {
            return (_service as IOperacijaService)!.Close(id);
        }
        [HttpPut("{id}/cancelled")]
        public Operacija Cancelled(int id)
        {
            return (_service as IOperacijaService)!.Cancelled(id);
        }
        [HttpGet("{id}/allowedActions")]
        public List<string> AllowedActions(int id)
        {
            return (_service as IOperacijaService)!.AllowedActions(id);
        }

        [HttpGet("zauzet-termin")]
        public ActionResult<List<string>> ZauzetTermin(int doktorId, DateTime datumOperacije)
        {
            var zauzetiTermini = _operacijaService.ZauzetTermin(doktorId, datumOperacije);
            return Ok(zauzetiTermini);
        }
    }
}
