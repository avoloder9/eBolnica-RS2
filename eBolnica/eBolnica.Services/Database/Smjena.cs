using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class Smjena
{
    public int SmjenaId { get; set; }

    public string? NazivSmjene { get; set; }

    public TimeSpan VrijemePocetka { get; set; }

    public TimeSpan VrijemeZavrsetka { get; set; }

    public virtual ICollection<RasporedSmjena> RasporedSmjenas { get; } = new List<RasporedSmjena>();
}
