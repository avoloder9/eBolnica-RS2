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
    public class OtpusnoPismoController : BaseCRUDController<OtpusnoPismo, OtpusnoPismoSearchObject, OtpusnoPismoInsertRequest, OtpusnoPismoUpdateRequest>
    {
        public OtpusnoPismoController(IOtpusnoPismoService service) : base(service) { }

        [Authorize(Roles = "Administrator,Doktor,Pacijent,MedicinskoOsoblje")]
        public override PagedResult<OtpusnoPismo> GetList([FromQuery] OtpusnoPismoSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Administrator,Doktor,Pacijent,MedicinskoOsoblje")]
        public override OtpusnoPismo GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Doktor")]
        public override OtpusnoPismo Insert(OtpusnoPismoInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Doktor")]
        public override OtpusnoPismo Update(int id, OtpusnoPismoUpdateRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "Administrator,Doktor")]
        public override void Delete(int id)
        {
            base.Delete(id);
        }
    }
}
