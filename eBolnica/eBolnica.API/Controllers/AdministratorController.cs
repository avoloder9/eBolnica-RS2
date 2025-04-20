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

    }
}
