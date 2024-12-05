using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class BolnicaInsertRequest
    {
        public string Naziv { get; set; } = null!;

        public string Adresa { get; set; } = null!;

        public string? Telefon { get; set; }

        public string Email { get; set; } = null!;

        public int? UkupanBrojSoba { get; set; }

        public int? UkupanBrojOdjela { get; set; }

        public int? TrenutniBrojHospitalizovanih { get; set; }
    }
}
