using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class SmjenaInsertRequest
    {
        public string? NazivSmjene { get; set; }

        public TimeSpan VrijemePocetka { get; set; }

        public TimeSpan VrijemeZavrsetka { get; set; }
    }
}
