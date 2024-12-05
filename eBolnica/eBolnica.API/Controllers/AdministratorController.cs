using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
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
    }
}
