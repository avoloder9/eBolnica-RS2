using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class SmjenaUpdateRequest
    {
        public TimeSpan VrijemePocetka { get; set; }

        public TimeSpan VrijemeZavrsetka { get; set; }
    }
}
