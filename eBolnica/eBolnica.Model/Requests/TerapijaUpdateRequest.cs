using eBolnica.Model.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class TerapijaUpdateRequest
    {
        public DateTime DatumPocetka { get; set; }

        public DateTime DatumZavrsetka { get; set; }
    }
}
