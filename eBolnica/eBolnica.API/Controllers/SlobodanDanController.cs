using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;

namespace eBolnica.API.Controllers
{
    public class SlobodanDanController : BaseCRUDController<SlobodniDan, SlobodniDanSearchObject, SlobodanDanInsertRequest, SlobodanDanUpdateRequest>
    {
        public SlobodanDanController(ISlobodanDanService service) : base(service) { }
    }
}
