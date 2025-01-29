using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using eBolnica.Services.Services;
using Microsoft.AspNetCore.Mvc;

namespace eBolnica.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class MedicinskoOsobljeController : BaseCRUDController<MedicinskoOsoblje, MedicinskoOsobljeSearchObject, MedicinskoOsobljeInsertRequest, MedicinskoOsobljeUpdateRequest>
    {
        private readonly IMedicinskoOsobljeService _medicinskoOsobljeService;
        public MedicinskoOsobljeController(IMedicinskoOsobljeService service) : base(service) { _medicinskoOsobljeService = service; }
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
    }
}
