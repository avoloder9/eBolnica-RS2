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
    }
}
