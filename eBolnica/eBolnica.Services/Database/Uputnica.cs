using eBolnica.Services.Interfaces;
using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class Uputnica : ISoftDelete
{
    public int UputnicaId { get; set; }

    public int TerminId { get; set; }

    public DateTime DatumKreiranja { get; set; }

    public bool Status { get; set; }

    public string? StateMachine { get; set; }
    public bool Obrisano { get; set; }
    public DateTime? VrijemeBrisanja { get; set; }
    public virtual ICollection<Pregled> Pregleds { get; } = new List<Pregled>();

    public virtual Termin Termin { get; set; } = null!;
}
