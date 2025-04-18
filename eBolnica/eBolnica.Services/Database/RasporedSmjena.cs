﻿using eBolnica.Services.Interfaces;
using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class RasporedSmjena : ISoftDelete
{
    public int RasporedSmjenaId { get; set; }

    public int SmjenaId { get; set; }

    public int KorisnikId { get; set; }

    public DateTime Datum { get; set; }
    public bool Obrisano { get; set; }
    public DateTime? VrijemeBrisanja { get; set; }
    public virtual Korisnik Korisnik { get; set; } = null!;

    public virtual ICollection<RadniSati> RadniSatis { get; } = new List<RadniSati>();

    public virtual Smjena Smjena { get; set; } = null!;
}
