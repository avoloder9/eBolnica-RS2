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
    public class SmjenaController : BaseCRUDController<Smjena, SmjenaSearchObject, SmjenaInsertRequest, SmjenaUpdateRequest>
    {
        public SmjenaController(ISmjenaService service) : base(service) { }

        [Authorize(Roles = "Administrator,MedicinskoOsoblje")]
        public override PagedResult<Smjena> GetList([FromQuery] SmjenaSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Administrator,MedicinskoOsoblje")]
        public override Smjena GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Administrator")]
        public override Smjena Insert(SmjenaInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Administrator")]
        public override Smjena Update(int id, SmjenaUpdateRequest request)
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
