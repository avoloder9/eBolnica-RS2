using eBolnica.Services.Interfaces;
using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class RadniSati : ISoftDelete
{
    public int RadniSatiId { get; set; }

    public int MedicinskoOsobljeId { get; set; }

    public int RasporedSmjenaId { get; set; }

    public TimeSpan VrijemeDolaska { get; set; }

    public TimeSpan? VrijemeOdlaska { get; set; }
    public bool Obrisano { get; set; }
    public DateTime? VrijemeBrisanja { get; set; }
    public virtual MedicinskoOsoblje MedicinskoOsoblje { get; set; } = null!;

    public virtual RasporedSmjena RasporedSmjena { get; set; } = null!;
}
