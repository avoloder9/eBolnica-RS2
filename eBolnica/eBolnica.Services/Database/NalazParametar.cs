using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class NalazParametar
{
    public int NalazParametarId { get; set; }

    public int LaboratorijskiNalazId { get; set; }

    public int ParametarId { get; set; }

    public decimal Vrijednost { get; set; }

    public virtual LaboratorijskiNalaz LaboratorijskiNalaz { get; set; } = null!;

    public virtual Parametar Parametar { get; set; } = null!;
}
