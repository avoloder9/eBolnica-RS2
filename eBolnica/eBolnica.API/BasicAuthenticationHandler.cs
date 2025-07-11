﻿using eBolnica.Services.Helpers;
using eBolnica.Services.Interfaces;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using System.Text.Encodings.Web;

namespace eBolnica.API
{
    public class BasicAuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
    {
        IKorisnikService _korisnikService;
        public BasicAuthenticationHandler(IOptionsMonitor<AuthenticationSchemeOptions> options, ILoggerFactory logger, UrlEncoder encoder, ISystemClock clock, IKorisnikService korisnikService) : base(options, logger, encoder, clock)
        {
            _korisnikService = korisnikService;
        }

        protected override async Task<AuthenticateResult> HandleAuthenticateAsync()
        {
            if (!Request.Headers.ContainsKey("Authorization"))
            {
                return AuthenticateResult.Fail("Missing header");
            }
            var authHeader = AuthenticationHeaderValue.Parse(Request.Headers["Authorization"]);
            var credentialsBytes = Convert.FromBase64String(authHeader.Parameter!);
            var credentials = Encoding.UTF8.GetString(credentialsBytes).Split(':');

            var username = credentials[0];
            var password = credentials[1];
            var authenticationResponse = await _korisnikService.AuthenticateUser(username, password);
            if (authenticationResponse.Result != AuthenticationResult.Success)
            {
                return AuthenticateResult.Fail("Auth failed");
            }
            else
            {
                var roles = new List<string>();

                if (_korisnikService.isKorisnikAdministrator(authenticationResponse!.UserId!.Value))
                    roles.Add("Administrator");

                if (_korisnikService.isKorisnikDoktor(authenticationResponse!.UserId!.Value))
                    roles.Add("Doktor");

                if (_korisnikService.isKorisnikMedicinskoOsoblje(authenticationResponse!.UserId!.Value))
                    roles.Add("MedicinskoOsoblje");

                if (_korisnikService.isKorisnikPacijent(authenticationResponse!.UserId!.Value))
                    roles.Add("Pacijent");

                var claims = new List<Claim>
                {
                    new Claim(ClaimTypes.Name, username),
                    new Claim(ClaimTypes.NameIdentifier, authenticationResponse.UserId.ToString()!)
                };

                foreach (var role in roles)
                {
                    claims.Add(new Claim(ClaimTypes.Role, role));
                }
                var identity = new ClaimsIdentity(claims, Scheme.Name);

                var principal = new ClaimsPrincipal(identity);

                var ticket = new AuthenticationTicket(principal, Scheme.Name);
                return AuthenticateResult.Success(ticket);
            }
        }
    }
}
