using eBolnica.Model;
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

        [Authorize(Roles = "Doktor")]
        [HttpPut("{id}/activate")]
        public Operacija Activate(int id)
        {
            return (_service as IOperacijaService)!.Activate(id);
        }

        [Authorize(Roles = "Doktor")]
        [HttpPut("{id}/update")]
        public Operacija Update(int id, OperacijaUpdateRequest request)
        {
            return (_service as IOperacijaService)!.Update(id, request);
        }

        [Authorize(Roles = "Doktor")]
        [HttpPut("{id}/edit")]
        public Operacija Edit(int id)
        {
            return (_service as IOperacijaService)!.Edit(id);
        }

        [Authorize(Roles = "Doktor")]
        [HttpPut("{id}/hide")]
        public Operacija Hide(int id)
        {
            return (_service as IOperacijaService)!.Hide(id);
        }

        [Authorize(Roles = "Doktor")]
        [HttpPut("{id}/close")]
        public Operacija Close(int id)
        {
            return (_service as IOperacijaService)!.Close(id);
        }

        [Authorize(Roles = "Doktor")]
        [HttpPut("{id}/cancelled")]
        public Operacija Cancelled(int id)
        {
            return (_service as IOperacijaService)!.Cancelled(id);
        }

        [Authorize(Roles = "Doktor")]
        [HttpGet("{id}/allowedActions")]
        public List<string> AllowedActions(int id)
        {
            return (_service as IOperacijaService)!.AllowedActions(id);
        }

        [Authorize(Roles = "Doktor")]
        [HttpGet("zauzet-termin")]
        public ActionResult<List<string>> ZauzetTermin(int doktorId, DateTime datumOperacije)
        {
            var zauzetiTermini = _operacijaService.ZauzetTermin(doktorId, datumOperacije);
            return Ok(zauzetiTermini);
        }

        [Authorize(Roles = "Administrator,Doktor,Pacijent,MedicinskoOsoblje")]
        public override PagedResult<Operacija> GetList([FromQuery] OperacijaSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Administrator,Doktor,Pacijent,MedicinskoOsoblje")]
        public override Operacija GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Doktor")]
        public override Operacija Insert(OperacijaInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Administrator,Doktor")]
        public override void Delete(int id)
        {
            base.Delete(id);
        }
    }
}
