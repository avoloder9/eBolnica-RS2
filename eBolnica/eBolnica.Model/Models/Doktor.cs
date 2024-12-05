using System;
using System.Collections.Generic;

namespace eBolnica.Model.Models
{

    public partial class Doktor
    {
        public int DoktorId { get; set; }
        public int KorisnikId { get; set; }
        public int OdjelId { get; set; }
        public string Specijalizacija { get; set; } = null!;
        public string? Biografija { get; set; }
        public virtual Korisnik Korisnik { get; set; } = null!;
        public virtual Odjel Odjel { get; set; } = null!;
    }
}