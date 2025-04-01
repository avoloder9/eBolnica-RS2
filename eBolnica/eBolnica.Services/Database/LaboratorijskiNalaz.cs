using eBolnica.Services.Interfaces;
using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class LaboratorijskiNalaz : ISoftDelete
{
    public int LaboratorijskiNalazId { get; set; }

    public int PacijentId { get; set; }

    public int DoktorId { get; set; }

    public DateTime DatumNalaza { get; set; }

    public virtual Doktor Doktor { get; set; } = null!;
    public bool Obrisano { get; set; }
    public DateTime? VrijemeBrisanja { get; set; }
    public virtual ICollection<NalazParametar> NalazParametars { get; } = new List<NalazParametar>();

    public virtual Pacijent Pacijent { get; set; } = null!;
}
