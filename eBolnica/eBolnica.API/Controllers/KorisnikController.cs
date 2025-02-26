using Azure.Core;
using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using eBolnica.Services.Helpers;
using Microsoft.EntityFrameworkCore;
using eBolnica.Services.Database;

namespace eBolnica.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KorisnikController : BaseCRUDController<Model.Models.Korisnik, KorisnikSearchObject, KorisnikInsertRequest, KorisnikUpdateRequest>
    {

        public readonly IKorisnikService korisnikService;
        private readonly EBolnicaContext Context;
        public KorisnikController(IKorisnikService service, EBolnicaContext dbContext) : base(service)
        {
            korisnikService = service;
            Context = dbContext;
        }

        [HttpPost("login")]
        [AllowAnonymous]
        public async Task<IActionResult> Login(LoginRequest request)
        {
            var authenticationResponse = await korisnikService.AuthenticateUser(request.Username, request.Password);
            String? userType;
            string? odjelNaziv=null;
            switch (authenticationResponse.Result)
            {
                case AuthenticationResult.Success:
                    var userId = authenticationResponse.UserId;
                    
                    if (korisnikService.isKorisnikDoktor((int)userId))
                    {
                        userType = "doktor";

                        var doktor=await Context.Doktors.Include(x=>x.Odjel).FirstOrDefaultAsync(x=>x.KorisnikId== userId);
                        if (doktor != null)
                        {
                            odjelNaziv = doktor.Odjel?.Naziv;
                        }
                    }
                    else if (korisnikService.isKorisnikPacijent((int)userId))
                    {
                        userType = "pacijent";
                    }
                    else if (korisnikService.isKorisnikAdministrator((int)userId))
                    {
                        userType = "administrator";
                    }
                    else if (korisnikService.isKorisnikMedicinskoOsoblje((int)userId))
                    {
                        userType = "medicinsko osoblje";
                    }
                    else
                    {
                        userType = null;
                    }
                    if (userType != null)
                    {
                        if (userType == "administrator" && request.DeviceType == "mobile")
                        {
                            return BadRequest("Administrator ne moze koristiti mobilnu aplikaciju");
                        }
                    }
                    return Ok(new { UserId = authenticationResponse.UserId, UserType = userType, Korisnik=authenticationResponse.Korisnik, Odjel=odjelNaziv });
                case AuthenticationResult.UserNotFound:
                    return BadRequest("Korisnik nije pronadjen.");
                default:
                    return StatusCode(500, "Doslo je do greske tokom autentifikacije");

            }
        }
    }
}