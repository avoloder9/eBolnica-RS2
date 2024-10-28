using eBolnica.Model.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class HospitalizacijaUpdateRequest
    {
        public DateTime? DatumOtpusta { get; set; }

        public int SobaId { get; set; }

        public int KrevetId { get; set; }

    }
}
