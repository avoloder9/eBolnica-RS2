using eBolnica.Services.Interfaces;
using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class Smjena : ISoftDelete
{
    public int SmjenaId { get; set; }

    public string? NazivSmjene { get; set; }

    public TimeSpan VrijemePocetka { get; set; }

    public TimeSpan VrijemeZavrsetka { get; set; }
    public bool Obrisano { get; set; }
    public DateTime? VrijemeBrisanja { get; set; }
    public virtual ICollection<RasporedSmjena> RasporedSmjenas { get; } = new List<RasporedSmjena>();
}
