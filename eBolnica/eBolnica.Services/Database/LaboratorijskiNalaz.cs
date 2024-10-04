using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class LaboratorijskiNalaz
{
    public int LaboratorijskiNalazId { get; set; }

    public int PacijentId { get; set; }

    public int DoktorId { get; set; }

    public DateTime DatumNalaza { get; set; }

    public virtual Doktor Doktor { get; set; } = null!;

    public virtual ICollection<NalazParametar> NalazParametars { get; } = new List<NalazParametar>();

    public virtual Pacijent Pacijent { get; set; } = null!;
}
