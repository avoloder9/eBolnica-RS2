using eBolnica.Model;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services;
using Microsoft.AspNetCore.Mvc;

namespace eBolnica.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class PacijentController : BaseCRUDController<Model.Pacijent, PacijentSearchObject, PacijentInsertRequest, PacijentUpdateRequest>
    {
        public PacijentController(IPacijentService service) : base(service) { }
    }
}
