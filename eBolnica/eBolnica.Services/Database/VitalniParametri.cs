using eBolnica.Services.Interfaces;
using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class VitalniParametri : ISoftDelete
{
    public int VitalniParametarId { get; set; }

    public int PacijentId { get; set; }

    public int OtkucajSrca { get; set; }

    public int Saturacija { get; set; }

    public decimal Secer { get; set; }

    public DateTime DatumMjerenja { get; set; }
    public TimeSpan VrijemeMjerenja { get; set; }
    public bool Obrisano { get; set; }
    public DateTime? VrijemeBrisanja { get; set; }
    public virtual Pacijent Pacijent { get; set; } = null!;
}
