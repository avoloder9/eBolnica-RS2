using eBolnica.Model;
using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using eBolnica.Services.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
namespace eBolnica.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class MedicinskoOsobljeController : BaseCRUDController<MedicinskoOsoblje, MedicinskoOsobljeSearchObject, MedicinskoOsobljeInsertRequest, MedicinskoOsobljeUpdateRequest>
    {
        private readonly IMedicinskoOsobljeService _medicinskoOsobljeService;
        public MedicinskoOsobljeController(IMedicinskoOsobljeService service) : base(service) { _medicinskoOsobljeService = service; }
     
        [Authorize(Roles = "Administrator,MedicinskoOsoblje")]
        [HttpGet("GetMedicinskoOsobljeIdByKorisnikId/{korisnikId}")]
        public IActionResult GetMedicinskoOsobljeIdByKorisnikId(int korisnikId)
        {
            int osobljeId = _medicinskoOsobljeService.GetOsobljeIdByKorisnikId(korisnikId);

            if (osobljeId != 0)
            {
                return Ok(osobljeId);
            }
            else
            {
                return NotFound();
            }
        }
      
        [Authorize(Roles = "Administrator,MedicinskoOsoblje")]
        [HttpGet("GetOdjelIdByMedicinskoOsoljeId/{osobljeId}")]
        public IActionResult GetOdjelIdByMedicinskoOsoljeId(int osobljeId)
        {
            int? odjelId = _medicinskoOsobljeService.GetOdjelIdByOsobljeId(osobljeId);

            if (odjelId != 0)
            {
                return Ok(odjelId);
            }
            else
            {
                return NotFound();
            }
        }

        [Authorize(Roles = "Administrator,Doktor,MedicinskoOsoblje")]
        public override PagedResult<MedicinskoOsoblje> GetList([FromQuery] MedicinskoOsobljeSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }
 
        [Authorize(Roles = "Administrator,Doktor,Pacijent,MedicinskoOsoblje")]
        public override MedicinskoOsoblje GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Administrator")]
        public override MedicinskoOsoblje Insert(MedicinskoOsobljeInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Administrator,MedicinskoOsoblje")]
        public override MedicinskoOsoblje Update(int id, MedicinskoOsobljeUpdateRequest request)
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
