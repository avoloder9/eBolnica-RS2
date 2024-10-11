using eBolnica.Model;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services;
using Microsoft.AspNetCore.Mvc;

namespace eBolnica.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KorisnikController : ControllerBase
    {
        protected IKorisnikService _service;
        public KorisnikController(IKorisnikService service)
        {
            _service = service;
        }
        [HttpGet]
        public PagedResult<Korisnik> GetList([FromQuery] KorisnikSearchObject searchObject)
        {
            return _service.GetList(searchObject);
        }
        [HttpPost]
        public Korisnik Insert(KorisnikInsertRequest request)
        {
            return _service.Insert(request);
        }
        [HttpPut("{id}")]
        public Korisnik Update(int id, KorisnikUpdateRequest request)
        {
            return _service.Update(id, request);
        }
    }
}