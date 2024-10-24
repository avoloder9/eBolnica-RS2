using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Models
{
    public partial class Korisnik
    {
        public int KorisnikId { get; set; }
        public string Ime { get; set; } = null!;
        public string Prezime { get; set; } = null!;
        public string Email { get; set; } = null!;

        public string KorisnickoIme { get; set; } = null!;
        //  public byte[]? Slika { get; set; }
        // public byte[]? SlikaThumb { get; set; }
        public DateTime? DatumRodjenja { get; set; }
        public string? Telefon { get; set; }
        public string? Spol { get; set; }
        public bool Status { get; set; }
    }
}
