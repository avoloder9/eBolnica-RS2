using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace eBolnica.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class StatusController : BaseCRUDController<Status, StatusSearchObject, StatusInsertRequest, StatusUpdateRequest>
    {
        public StatusController(IStatusService service) : base(service) { }
    }
}
