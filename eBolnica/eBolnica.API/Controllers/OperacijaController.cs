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
    }
}
