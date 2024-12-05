using System;
using System.Collections.Generic;

namespace eBolnica.Model.Models
{
    public partial class Smjena
    {
        public int SmjenaId { get; set; }

        public string? NazivSmjene { get; set; }

        public TimeSpan VrijemePocetka { get; set; }

        public TimeSpan VrijemeZavrsetka { get; set; }
    }
}