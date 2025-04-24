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
    public class MedicinskaDokumentacijaController : BaseCRUDController<MedicinskaDokumentacija, MedicinskaDokumentacijaSearchObject, MedicinskaDokumentacijaInsertRequest, MedicinskaDokumentacijaUpdateRequest>
    {
        private readonly IMedicinskaDokumentacijaService _medicinskaDokumentacijaService;
        public MedicinskaDokumentacijaController(IMedicinskaDokumentacijaService service) : base(service) { _medicinskaDokumentacijaService = service; }

        [Authorize(Roles = "Administrator,Doktor,Pacijent,MedicinskoOsoblje")]
        [HttpGet("getMedicinskaDokumentacija/{pacijentId}")]
        public IActionResult GetByPacijentId(int pacijentId)
        {
            var dokumentacija = _medicinskaDokumentacijaService.GetByPacijentId(pacijentId);
            if (dokumentacija == null)
                return NotFound();

            return Ok(dokumentacija);
        }

        [Authorize(Roles = "Administrator,Doktor,Pacijent,MedicinskoOsoblje")]
        public override PagedResult<MedicinskaDokumentacija> GetList([FromQuery] MedicinskaDokumentacijaSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }
   
        [Authorize(Roles = "Administrator,Doktor,Pacijent,MedicinskoOsoblje")]
        public override MedicinskaDokumentacija GetById(int id)
        {
            return base.GetById(id);
        }
     
        [Authorize(Roles = "MedicinskoOsoblje")]
        public override MedicinskaDokumentacija Insert(MedicinskaDokumentacijaInsertRequest request)
        {
            return base.Insert(request);
        }
     
        [Authorize(Roles = "Doktor,MedicinskoOsoblje")]
        public override MedicinskaDokumentacija Update(int id, MedicinskaDokumentacijaUpdateRequest request)
        {
            return base.Update(id, request);
        }
 
        [Authorize(Roles = "Administrator,MedicinskoOsoblje")]
        public override void Delete(int id)
        {
            base.Delete(id);
        }

    }
}
