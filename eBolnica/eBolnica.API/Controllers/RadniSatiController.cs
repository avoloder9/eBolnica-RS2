using eBolnica.Model;
using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
namespace eBolnica.API.Controllers
{
    public class RadniSatiController : BaseCRUDController<RadniSati, RadniSatiSearchObject, RadniSatiInsertRequest, RadniSatiUpdateRequest>
    {
        public RadniSatiController(IRadniSatiService service) : base(service) { }

        [Authorize(Roles = "Administrator,MedicinskoOsoblje")]
        public override PagedResult<RadniSati> GetList([FromQuery] RadniSatiSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Administrator,MedicinskoOsoblje")]
        public override RadniSati GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Administrator,MedicinskoOsoblje")]
        public override RadniSati Insert(RadniSatiInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Administrator,MedicinskoOsoblje")]
        public override RadniSati Update(int id, RadniSatiUpdateRequest request)
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
