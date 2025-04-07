using eBolnica.Services.Interfaces;
using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class SlobodniDan : ISoftDelete
{
    public int SlobodniDanId { get; set; }

    public int KorisnikId { get; set; }

    public DateTime Datum { get; set; }

    public string Razlog { get; set; } = null!;

    public bool? Status { get; set; }
    public bool Obrisano { get; set; }
    public DateTime? VrijemeBrisanja { get; set; }
    public virtual Korisnik Korisnik { get; set; } = null!;
}
