using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace eBolnica.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class MedicinskoOsobljeController : BaseCRUDController<MedicinskoOsoblje, MedicinskoOsobljeSearchObject, MedicinskoOsobljeInsertRequest, MedicinskoOsobljeUpdateRequest>
    {
        public MedicinskoOsobljeController(IMedicinskoOsobljeService service) : base(service) { }
    }
}
