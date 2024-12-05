using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace eBolnica.Model.Requests
{
    public class DoktorInsertRequest
    {
        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public string Email { get; set; } = null!;

        public string KorisnickoIme { get; set; } = null!;

        public string Lozinka { get; set; } = null!;

        public string LozinkaPotvrda { get; set; } = null!;

        public byte[]? Slika { get; set; }

        public byte[]? SlikaThumb { get; set; }

        public DateTime? DatumRodjenja { get; set; }

        public string? Telefon { get; set; }

        public string? Spol { get; set; }

        public bool Status { get; set; } = true;
        public string Specijalizacija { get; set; } = null!;
        public string? Biografija { get; set; }
        public int OdjelId { get; set; }

        [JsonIgnore]
        public int? KorisnikId { get; set; }
    }
}
