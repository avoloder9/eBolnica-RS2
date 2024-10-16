using eBolnica.Model;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services;
using Microsoft.AspNetCore.Mvc;

namespace eBolnica.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class AdministratorController : BaseCRUDController<Model.Administrator, AdministratorSearchObject, AdministratorInsertRequest, AdministratorUpdateRequest>
    {
        private readonly IAdministratorService _administratorService;

        public AdministratorController(IAdministratorService service) : base(service)
        {
            _administratorService = service;
        }

        [HttpPost("CreateAdministratorWithUserDetails")]
        public IActionResult InsertAdministratorWithUserDetails([FromBody] AdministratorInsertRequest request)
        {
            try
            {
                var createdAdmin = _administratorService.InsertAdministratorWithUserDetails(request);
                return Ok(createdAdmin);
            }
            catch (Exception ex)
            {
                return StatusCode(500, "An error occurred while creating the tourist.");
            }
        }
    }
}
