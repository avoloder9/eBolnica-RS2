using eBolnica.Services.Interfaces;
using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class NalazParametar : ISoftDelete
{
    public int NalazParametarId { get; set; }

    public int LaboratorijskiNalazId { get; set; }

    public int ParametarId { get; set; }

    public decimal Vrijednost { get; set; }
    public bool Obrisano { get; set; }
    public DateTime? VrijemeBrisanja { get; set; }
    public virtual LaboratorijskiNalaz LaboratorijskiNalaz { get; set; } = null!;

    public virtual Parametar Parametar { get; set; } = null!;
}
