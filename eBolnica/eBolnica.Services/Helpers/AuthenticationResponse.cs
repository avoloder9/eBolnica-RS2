using Microsoft.Identity.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.Helpers
{
    public enum AuthenticationResult
    {
        Success,
        UserNotFound,
        InvalidPassword
    }
    public class AuthenticationResponse
    {
        public AuthenticationResult Result { get; set; }
        public int? UserId { get; set; }
    }
}
