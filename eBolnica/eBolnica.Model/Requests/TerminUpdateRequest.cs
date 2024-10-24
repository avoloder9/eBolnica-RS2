using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class TerminUpdateRequest
    {
        public DateTime DatumTermina { get; set; }

        public TimeSpan VrijemeTermina { get; set; }
        public bool? Otkazano { get; set; }
    }
}
