using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;

namespace eBolnica.API.Controllers
{
    public class SlobodniDanController : BaseCRUDController<SlobodniDan, SlobodniDanSearchObject, SlobodniDanInsertRequest, SlobodniDanUpdateRequest>
    {
        public SlobodniDanController(ISlobodniDanService service) : base(service) { }
    }
}
