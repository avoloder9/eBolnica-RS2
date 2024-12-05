using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class Operacija
{
    public int OperacijaId { get; set; }

    public int PacijentId { get; set; }

    public int DoktorId { get; set; }

    public DateTime DatumOperacije { get; set; }

    public int? TerapijaId { get; set; }

    public string TipOperacije { get; set; } = null!;

    public string? StateMachine { get; set; }

    public string? Komentar { get; set; }

    public virtual Doktor Doktor { get; set; } = null!;

    public virtual Pacijent Pacijent { get; set; } = null!;

    public virtual Terapija? Terapija { get; set; }
}
