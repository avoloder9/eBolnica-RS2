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
    public class PregledController : BaseCRUDController<Pregled, PregledSearchObject, PregledInsertRequest, PregledUpdateRequest>
    {
        private readonly IPregledService _pregledService;
        public PregledController(IPregledService service) : base(service) { _pregledService = service; }

        [Authorize(Roles = "Administrator")]
        [HttpGet("broj-pregleda")]
        public IActionResult GetBrojPregledaPoDanu([FromQuery] int brojDana)
        {
            var result = _pregledService.GetBrojPregledaPoDanu(brojDana);
            return Ok(result);
        }

        [Authorize(Roles = "Administrator,Doktor,Pacijent,MedicinskoOsoblje")]
        public override PagedResult<Pregled> GetList([FromQuery] PregledSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Administrator,Doktor,Pacijent,MedicinskoOsoblje")]
        public override Pregled GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Doktor")]
        public override Pregled Insert(PregledInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Doktor")]
        public override Pregled Update(int id, PregledUpdateRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "Doktor")]
        public override void Delete(int id)
        {
            base.Delete(id);
        }

    }
}
