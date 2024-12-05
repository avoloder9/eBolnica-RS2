using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace eBolnica.Model.Requests
{
    public class MedicinskoOsobljeUpdateRequest
    {
        public string Ime { get; set; } = null!;
        public string Prezime { get; set; } = null!;
        public string? Lozinka { get; set; } = null!;
        public string? LozinkaPotvrda { get; set; } = null!;
        public byte[]? Slika { get; set; }
        public byte[]? SlikaThumb { get; set; }
        public string? Telefon { get; set; }
        public bool Status { get; set; } = true;
        public int OdjelId { get; set; }

        [JsonIgnore]
        public int? KorisnikID { get; set; }
    }
}
