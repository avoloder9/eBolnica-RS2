using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eBolnica.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class OperacijaController : BaseCRUDController<Operacija, OperacijaSearchObject, OperacijaInsertRequest, OperacijaUpdateRequest>
    {
        public OperacijaController(IOperacijaService service) : base(service) { }
        [HttpGet("GetByPacijentId")]
        public List<Model.Models.Operacija> GetOperacijaByPacijentId([FromQuery] int pacijentId)
        {
            return (_service as IOperacijaService).GetOperacijaByPacijentId(pacijentId);
        }
        [HttpPut("{id}/activate")]
        public Operacija Activate(int id)
        {
            return (_service as IOperacijaService).Activate(id);
        }
        [HttpPut("{id}/edit")]
        public Operacija Edit(int id)
        {
            return (_service as IOperacijaService).Edit(id);
        }

        [HttpPut("{id}/hide")]
        public Operacija Hide(int id)
        {
            return (_service as IOperacijaService).Hide(id);
        }
        [HttpPut("{id}/close")]
        public Operacija Close(int id)
        {
            return (_service as IOperacijaService).Close(id);
        }
        [HttpPut("{id}/cancelled")]
        public Operacija Cancelled(int id)
        {
            return (_service as IOperacijaService).Cancelled(id);
        }
        [HttpGet("{id}/allowedActions")]
        public List<string> AllowedActions(int id)
        {
            return (_service as IOperacijaService).AllowedActions(id);
        }
    }
}
