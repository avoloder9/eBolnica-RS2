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
    public class DoktorController : BaseCRUDController<Doktor, DoktorSearchObject, DoktorInsertRequest, DoktorUpdateRequest>
    {
        private readonly IDoktorService _doktorService;
        public DoktorController(IDoktorService service) : base(service)
        {
            _doktorService = service;
        }

        [Authorize(Roles = "Administrator,Doktor,Pacijent,MedicinskoOsoblje")]
        public override PagedResult<Doktor> GetList([FromQuery] DoktorSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Administrator,Doktor,Pacijent,MedicinskoOsoblje")]
        public override Doktor GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Administrator")]
        public override Doktor Insert(DoktorInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Administrator,Doktor")]
        public override Doktor Update(int id, DoktorUpdateRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "Administrator")]
        public override void Delete(int id)
        {
            base.Delete(id);
        }

        [Authorize(Roles = "Doktor")]
        [HttpGet("GetDoktorIdByKorisnikId/{korisnikId}")]
        public IActionResult GetDoktorIdByKorisnikId(int korisnikId)
        {
            int doktorId = _doktorService.GetDoktorIdByKorisnikId(korisnikId);

            if (doktorId != 0)
            {
                return Ok(doktorId);
            }
            else
            {
                return NotFound();
            }
        }

        [Authorize(Roles = "Administrator,Doktor")]
        [HttpGet("GetDnevniRaspored/{doktorId}")]
        public async Task<IActionResult> GetDnevniRaspored(int doktorId)
        {
            var raspored = await _doktorService.GetDnevniRasporedAsync(doktorId);
            return Ok(raspored);
        }
    }
}
