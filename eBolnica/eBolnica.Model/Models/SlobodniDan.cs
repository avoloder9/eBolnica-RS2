﻿using System;
using System.Collections.Generic;

namespace eBolnica.Model.Models
{
    public partial class SlobodniDan
    {
        public int SlobodniDanId { get; set; }

        public int KorisnikId { get; set; }

        public DateTime Datum { get; set; }

        public string Razlog { get; set; } = null!;

        public bool? Status { get; set; }

        public virtual Korisnik Korisnik { get; set; } = null!;
    }
}
