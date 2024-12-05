using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace eBolnica.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class OdjelController : BaseCRUDController<Odjel, OdjelSearchObject, OdjelInsertRequest, OdjelUpdateRequest>
    {

        public OdjelController(IOdjelService service) : base(service)
        { }

    }
}
