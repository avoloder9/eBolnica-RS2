using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace eBolnica.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UputnicaController : BaseCRUDController<Uputnica, UputnicaSearchObject, UputnicaInsertRequest, UputnicaUpdateRequest>
    {
        public UputnicaController(IUputnicaService service) : base(service) { }

        [HttpPut("{id}/activate")]
        public Uputnica Activate(int id)
        {
            return (_service as IUputnicaService)!.Activate(id);
        }
        [HttpPut("{id}/edit")]
        public Uputnica Edit(int id)
        {
            return (_service as IUputnicaService)!.Edit(id);
        }

        [HttpPut("{id}/hide")]
        public Uputnica Hide(int id)
        {
            return (_service as IUputnicaService)!.Hide(id);
        }
        [HttpPut("{id}/close")]
        public Uputnica Close(int id)
        {
            return (_service as IUputnicaService)!.Close(id);
        }
        [HttpGet("{id}/allowedActions")]
        public List<string> AllowedActions(int id)
        {
            return (_service as IUputnicaService)!.AllowedActions(id);
        }
    }
}
