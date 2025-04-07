using eBolnica.Services.Interfaces;
using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class Terapija : ISoftDelete
{
    public int TerapijaId { get; set; }

    public string Naziv { get; set; } = null!;

    public string Opis { get; set; } = null!;

    public DateTime DatumPocetka { get; set; }

    public DateTime DatumZavrsetka { get; set; }

    public int? PregledId { get; set; }
    public bool Obrisano { get; set; }
    public DateTime? VrijemeBrisanja { get; set; }
    public virtual ICollection<Operacija> Operacijas { get; } = new List<Operacija>();

    public virtual ICollection<OtpusnoPismo> OtpusnoPismos { get; } = new List<OtpusnoPismo>();

    public virtual Pregled? Pregled { get; set; } = null!;
}
