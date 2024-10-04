using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class Uputnica
{
    public int UputnicaId { get; set; }

    public int TerminId { get; set; }

    public int StatusId { get; set; }

    public DateTime DatumKreiranja { get; set; }

    public virtual ICollection<Pregled> Pregleds { get; } = new List<Pregled>();

    public virtual Status Status { get; set; } = null!;

    public virtual Termin Termin { get; set; } = null!;
}
