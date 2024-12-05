using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class MedicinskaDokumentacijaUpdateRequest
    {
        public bool? Hospitalizovan { get; set; }
        public string? Napomena { get; set; }
    }
}
