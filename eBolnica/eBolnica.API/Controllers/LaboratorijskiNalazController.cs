using eBolnica.Model;
using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
namespace eBolnica.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class LaboratorijskiNalazController : BaseCRUDController<LaboratorijskiNalaz, LaboratorijskiNalazSearchObject, LaboratorijskiNalazInsertRequest, LaboratorijskiNalazUpdateRequest>
    {
        public LaboratorijskiNalazController(ILaboratorijskiNalazService service) : base(service) { }

        [Authorize(Roles = "Administrator,Doktor,Pacijent,MedicinskoOsoblje")]
        public override PagedResult<LaboratorijskiNalaz> GetList([FromQuery] LaboratorijskiNalazSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Administrator,Doktor,Pacijent,MedicinskoOsoblje")]
        public override LaboratorijskiNalaz GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "MedicinskoOsoblje")]
        public override LaboratorijskiNalaz Insert(LaboratorijskiNalazInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "MedicinskoOsoblje")]
        public override LaboratorijskiNalaz Update(int id, LaboratorijskiNalazUpdateRequest request)
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
