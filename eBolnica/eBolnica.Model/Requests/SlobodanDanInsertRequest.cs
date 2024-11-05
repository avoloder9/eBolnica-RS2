using eBolnica.Model.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class SlobodanDanInsertRequest
    {
        public int KorisnikId { get; set; }

        public DateTime Datum { get; set; }

        public string Razlog { get; set; } = null!;

        public string Status { get; set; } = null!;
    }
}
