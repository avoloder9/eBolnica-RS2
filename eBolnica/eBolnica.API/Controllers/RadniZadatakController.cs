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
    public class RadniZadatakController : BaseCRUDController<RadniZadatak, RadniZadatakSearchObject, RadniZadatakInsertRequest, RadniZadatakUpdateRequest>
    {
        public RadniZadatakController(IRadniZadatakService service) : base(service) { }

        [Authorize(Roles = "Administrator,Doktor,MedicinskoOsoblje")]
        [HttpGet("osoblje-na-smjeni")]
        public IActionResult DohvatiOsobljeNaSmjeni(DateTime datumZadatka)
        {
            var trenutnoOsoblje = (_service as IRadniZadatakService)!.GetMedicinskoOsobljeNaSmjeni(datumZadatka, datumZadatka.TimeOfDay);
            return Ok(trenutnoOsoblje);
        }

        [Authorize(Roles = "Administrator,Doktor,MedicinskoOsoblje")]
        public override PagedResult<RadniZadatak> GetList([FromQuery] RadniZadatakSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Administrator,Doktor,MedicinskoOsoblje")]
        public override RadniZadatak GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Doktor")]
        public override RadniZadatak Insert(RadniZadatakInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Doktor,MedicinskoOsoblje")]
        public override RadniZadatak Update(int id, RadniZadatakUpdateRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "Doktor,MedicinskoOsoblje")]
        public override void Delete(int id)
        {
            base.Delete(id);
        }

    }
}
