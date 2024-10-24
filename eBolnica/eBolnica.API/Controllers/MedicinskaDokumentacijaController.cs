using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;

namespace eBolnica.API.Controllers
{
    public class MedicinskaDokumentacijaController : BaseCRUDController<MedicinskaDokumentacija, MedicinskaDokumentacijaSearchObject, MedicinskaDokumentacijaInsertRequest, MedicinskaDokumentacijaUpdateRequest>
    {
        public MedicinskaDokumentacijaController(IMedicinskaDokumentacijaService service) : base(service) { }
    }
}
