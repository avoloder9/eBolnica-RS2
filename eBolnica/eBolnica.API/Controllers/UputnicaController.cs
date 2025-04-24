using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using eBolnica.Model;

namespace eBolnica.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UputnicaController : BaseCRUDController<Uputnica, UputnicaSearchObject, UputnicaInsertRequest, UputnicaUpdateRequest>
    {
        public UputnicaController(IUputnicaService service) : base(service) { }

        [Authorize(Roles = "MedicinskoOsoblje")]
        [HttpPut("{id}/activate")]
        public Uputnica Activate(int id)
        {
            return (_service as IUputnicaService)!.Activate(id);
        }

        [Authorize(Roles = "MedicinskoOsoblje")]
        [HttpPut("{id}/edit")]
        public Uputnica Edit(int id)
        {
            return (_service as IUputnicaService)!.Edit(id);
        }

        [Authorize(Roles = "MedicinskoOsoblje")]
        [HttpPut("{id}/hide")]
        public Uputnica Hide(int id)
        {
            return (_service as IUputnicaService)!.Hide(id);
        }

        [Authorize(Roles = "MedicinskoOsoblje")]
        [HttpPut("{id}/close")]
        public Uputnica Close(int id)
        {
            return (_service as IUputnicaService)!.Close(id);
        }

        [Authorize(Roles = "MedicinskoOsoblje")]
        [HttpGet("{id}/allowedActions")]
        public List<string> AllowedActions(int id)
        {
            return (_service as IUputnicaService)!.AllowedActions(id);
        }

        [Authorize(Roles = "Administrator,Doktor,MedicinskoOsoblje")]
        public override PagedResult<Uputnica> GetList([FromQuery] UputnicaSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }
      
        [Authorize(Roles = "Administrator,Doktor,MedicinskoOsoblje")]
        public override Uputnica GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "MedicinskoOsoblje")]
        public override Uputnica Insert(UputnicaInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "MedicinskoOsoblje")]
        public override Uputnica Update(int id, UputnicaUpdateRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "MedicinskoOsoblje")]
        public override void Delete(int id)
        {
            base.Delete(id);
        }

    }
}
