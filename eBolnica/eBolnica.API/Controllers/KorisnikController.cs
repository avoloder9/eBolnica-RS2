using eBolnica.Model;
using eBolnica.Model.Requests;
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
        public List<Korisnik> GetList()
        {
            return _service.GetList();
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