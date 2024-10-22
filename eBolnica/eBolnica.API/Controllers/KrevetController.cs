using eBolnica.Model;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services;
using Microsoft.AspNetCore.Mvc;

namespace eBolnica.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KrevetController : BaseCRUDController<Krevet, KrevetSearchObject, KrevetInsertRequest, KrevetUpdateRequest>
    {
        public KrevetController(IKrevetService service) : base(service) { }
    }
}
