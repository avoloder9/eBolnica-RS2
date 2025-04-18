﻿using System;
using System.Collections.Generic;

namespace eBolnica.Model.Models
{
    public partial class Pacijent
    {
        public int PacijentId { get; set; }

        public int KorisnikId { get; set; }

        public int BrojZdravstveneKartice { get; set; }

        public string Adresa { get; set; } = null!;

        public int Dob { get; set; }
        public bool Obrisano { get; set; }
        public virtual Korisnik? Korisnik { get; set; } = null!;
    }
}