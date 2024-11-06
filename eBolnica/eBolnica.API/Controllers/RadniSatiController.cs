using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;

namespace eBolnica.API.Controllers
{
    public class RadniSatiController : BaseCRUDController<RadniSati, RadniSatiSearchObject, RadniSatiInsertRequest, RadniSatiUpdateRequest>
    {
        public RadniSatiController(IRadniSatiService service) : base(service) { }
    }
}
