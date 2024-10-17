using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services;
using Microsoft.AspNetCore.Mvc;

namespace eBolnica.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class BolnicaController : BaseCRUDController<Model.Bolnica, BolnicaSearchObject, BolnicaInsertRequest, BolnicaUpdateRequest>
    {
        public BolnicaController(IBolnicaService service) : base(service) { }
    }
}
