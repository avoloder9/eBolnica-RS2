using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace eBolnica.Model.Requests
{
    public class OdjelInsertRequest
    {
        public string Naziv { get; set; } = null!;

        public int? BrojSoba { get; set; } = 0;

        public int? BrojKreveta { get; set; } = 0;

        public int? BrojSlobodnihKreveta { get; set; } = 0;

        public int BolnicaId { get; set; }

        public int? GlavniDoktorId { get; set; } = null;


    }
}
