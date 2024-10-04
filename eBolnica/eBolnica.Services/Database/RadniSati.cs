using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class RadniSati
{
    public int RadniSatiId { get; set; }

    public int MedicinskoOsobljeId { get; set; }

    public int RasporedSmjenaId { get; set; }

    public TimeSpan VrijemeDolaska { get; set; }

    public TimeSpan? VrijemeOdlaska { get; set; }

    public virtual MedicinskoOsoblje MedicinskoOsoblje { get; set; } = null!;

    public virtual RasporedSmjena RasporedSmjena { get; set; } = null!;
}
