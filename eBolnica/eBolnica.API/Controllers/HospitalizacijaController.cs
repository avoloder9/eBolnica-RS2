using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;

namespace eBolnica.API.Controllers
{
    public class HospitalizacijaController : BaseCRUDController<Hospitalizacija, HospitalizacijaSearchObject, HospitalizacijaInsertRequest, HospitalizacijaUpdateRequest>
    {
        public HospitalizacijaController(IHospitalizacijaService service) : base(service) { }
    }
}
