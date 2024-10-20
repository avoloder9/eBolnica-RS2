using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class OdjelUpdateRequest
    {
        public string Naziv { get; set; } = null!;
        public int GlavniDoktorId { get; set; }
    }
}
