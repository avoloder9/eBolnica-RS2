using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class VitalniParametri
{
    public int VitalniParametarId { get; set; }

    public int PacijentId { get; set; }

    public int OtkucajSrca { get; set; }

    public int Saturacija { get; set; }

    public decimal Secer { get; set; }

    public DateTime DatumMjerenja { get; set; }

    public virtual Pacijent Pacijent { get; set; } = null!;
}
