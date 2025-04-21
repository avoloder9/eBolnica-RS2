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
    public class HospitalizacijaController : BaseCRUDController<Hospitalizacija, HospitalizacijaSearchObject, HospitalizacijaInsertRequest, HospitalizacijaUpdateRequest>
    {
        public HospitalizacijaController(IHospitalizacijaService service) : base(service) { }

        [Authorize(Roles = "Administrator,Doktor,MedicinskoOsoblje")]
        public override PagedResult<Hospitalizacija> GetList([FromQuery] HospitalizacijaSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }
        [Authorize(Roles = "Administrator,Doktor,MedicinskoOsoblje")]
        public override Hospitalizacija GetById(int id)
        {
            return base.GetById(id);
        }
        [Authorize(Roles = "Administrator,Doktor")]
        public override Hospitalizacija Insert(HospitalizacijaInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Administrator,Doktor")]
        public override Hospitalizacija Update(int id, HospitalizacijaUpdateRequest request)
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
