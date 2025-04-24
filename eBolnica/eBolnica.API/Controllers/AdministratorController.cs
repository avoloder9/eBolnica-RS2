using eBolnica.Model;
using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using eBolnica.Services.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eBolnica.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class AdministratorController : BaseCRUDController<Administrator, AdministratorSearchObject, AdministratorInsertRequest, AdministratorUpdateRequest>
    {
        private readonly IAdministratorService _administratorService;

        public AdministratorController(IAdministratorService service) : base(service)
        {
            _administratorService = service;
        }

        [Authorize(Roles = "Administrator")]
        [HttpGet("GetAdministratorIdByKorisnikId/{korisnikId}")]
        public IActionResult GetAdministratorIdByUserId(int korisnikId)
        {
            int adminId = _administratorService.GetAdministratorIdByKorisnikId(korisnikId);

            if (adminId != 0)
            {
                return Ok(adminId);
            }
            else
            {
                return NotFound();
            }
        }

        [Authorize(Roles = "Administrator")]
        [HttpGet("dashboard-data")]
        public IActionResult GetDashboardData()
        {
            var result = _administratorService.GetDashboardData();
            return Ok(result);
        }

        [Authorize(Roles = "Administrator")]
        public override Administrator Insert(AdministratorInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Administrator")]
        public override Administrator Update(int id, AdministratorUpdateRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "Administrator")]
        public override Administrator GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Administrator")]
        public override PagedResult<Administrator> GetList([FromQuery] AdministratorSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Administrator")]
        public override void Delete(int id)
        {
            base.Delete(id);
        }
    }
}
