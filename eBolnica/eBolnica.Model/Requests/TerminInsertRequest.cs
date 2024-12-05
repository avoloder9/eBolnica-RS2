using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class TerminInsertRequest
    {
        public int PacijentId { get; set; }

        public int DoktorId { get; set; }

        public int OdjelId { get; set; }

        public DateTime DatumTermina { get; set; }

        public TimeSpan VrijemeTermina { get; set; }

        public bool? Otkazano { get; set; } = false;
    }
}
