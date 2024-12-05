using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace eBolnica.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class RasporedSmjenaController : BaseCRUDController<RasporedSmjena, RasporedSmjenaSearchObject, RasporedSmjenaInsertRequest, RasporedSmjenaUpdateRequest>
    {
        public RasporedSmjenaController(IRasporedSmjenaService service) : base(service) { }
    }
}
