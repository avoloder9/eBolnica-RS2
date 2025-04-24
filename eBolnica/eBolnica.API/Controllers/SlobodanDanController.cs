using eBolnica.Model;
using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
namespace eBolnica.API.Controllers
{
    public class SlobodniDanController : BaseCRUDController<SlobodniDan, SlobodniDanSearchObject, SlobodniDanInsertRequest, SlobodniDanUpdateRequest>
    {
        public SlobodniDanController(ISlobodniDanService service) : base(service) { }

        [Authorize(Roles = "Administrator,MedicinskoOsoblje")]
        public override PagedResult<SlobodniDan> GetList([FromQuery] SlobodniDanSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Administrator,MedicinskoOsoblje")]
        public override SlobodniDan GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Administrator,MedicinskoOsoblje")]
        public override SlobodniDan Insert(SlobodniDanInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Administrator,MedicinskoOsoblje")]
        public override SlobodniDan Update(int id, SlobodniDanUpdateRequest request)
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
