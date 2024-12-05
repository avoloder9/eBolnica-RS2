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
    public class RadniZadatakController : BaseCRUDController<RadniZadatak, RadniZadatakSearchObject, RadniZadatakInsertRequest, RadniZadatakUpdateRequest>
    {
        public RadniZadatakController(IRadniZadatakService service) : base(service) { }
        [HttpGet("osoblje-na-smjeni")]
        public IActionResult DohvatiOsobljeNaSmjeni(DateTime datumZadatka)
        {
            var trenutnoOsoblje = (_service as IRadniZadatakService).GetMedicinskoOsobljeNaSmjeni(datumZadatka, datumZadatka.TimeOfDay);
            return Ok(trenutnoOsoblje);
        }

    }
}
