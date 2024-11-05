using eBolnica.Model.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class RasporedSmjenaInsertRequest
    {
        public int SmjenaId { get; set; }

        public int KorisnikId { get; set; }

        public DateTime Datum { get; set; }

    }
}
