using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using eBolnica.Services.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using eBolnica.Model;

namespace eBolnica.API.Controllers
{

    [ApiController]
    [Route("[controller]")]
    public class TerapijaController : BaseCRUDController<Terapija, TerapijaSearchObject, TerapijaInsertRequest, TerapijaUpdateRequest>
    {
        private readonly ITerapijaService terapijaService;
        public TerapijaController(ITerapijaService service) : base(service) { terapijaService = service; }

        [Authorize(Roles = "Administrator,Doktor,Pacijent,MedicinskoOsoblje")]
        [HttpGet("getTerapijabyPregledId/{pregledId}")]
        public IActionResult GetTerapijaByPregledId(int pregledId)
        {
            var terapija = terapijaService.GetTerapijaByPregledId(pregledId);
            if (terapija == null)
            {
                return NotFound();
            }
            return Ok(terapija);

        }

        [Authorize(Roles = "Administrator,Doktor,Pacijent,MedicinskoOsoblje")]
        public override PagedResult<Terapija> GetList([FromQuery] TerapijaSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Administrator,Doktor,Pacijent,MedicinskoOsoblje")]
        public override Terapija GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Doktor")]
        public override Terapija Insert(TerapijaInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Doktor")]
        public override Terapija Update(int id, TerapijaUpdateRequest request)
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