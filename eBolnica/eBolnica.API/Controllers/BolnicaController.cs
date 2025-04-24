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
    public class BolnicaController : BaseCRUDController<Bolnica, BolnicaSearchObject, BolnicaInsertRequest, BolnicaUpdateRequest>
    {
        public BolnicaController(IBolnicaService service) : base(service) { }

        [Authorize(Roles = "Administrator,MedicinskoOsoblje,Doktor,Pacijent")]
        public override PagedResult<Bolnica> GetList([FromQuery] BolnicaSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Administrator,MedicinskoOsoblje,Doktor,Pacijent")]
        public override Bolnica GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Administrator")]
        public override Bolnica Insert(BolnicaInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Administrator")]
        public override Bolnica Update(int id, BolnicaUpdateRequest request)
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
