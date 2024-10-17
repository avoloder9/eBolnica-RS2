using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class BolnicaUpdateRequest
    {
        public string? Telefon { get; set; }

        public int? UkupanBrojSoba { get; set; }

        public int? UkupanBrojOdjela { get; set; }

        public int? TrenutniBrojHospitalizovanih { get; set; }
    }
}
