using eBolnica.Model;
using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Data;

namespace eBolnica.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class VitalniParametriController : BaseCRUDController<VitalniParametri, VitalniParametriSearchObject, VitalniParametriInsertRequest, VitalniParametriUpdateRequest>
    {
        public VitalniParametriController(IVitalniParametriService service) : base(service) { }

        [Authorize(Roles = "Doktor,MedicinskoOsoblje")]
        public override PagedResult<VitalniParametri> GetList([FromQuery] VitalniParametriSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }
     
        [Authorize(Roles = "Doktor,MedicinskoOsoblje")]
        public override VitalniParametri GetById(int id)
        {
            return base.GetById(id);
        }
     
        [Authorize(Roles = "MedicinskoOsoblje")]
        public override VitalniParametri Insert(VitalniParametriInsertRequest request)
        {
            return base.Insert(request);
        }
     
        [Authorize(Roles = "MedicinskoOsoblje")]
        public override VitalniParametri Update(int id, VitalniParametriUpdateRequest request)
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
