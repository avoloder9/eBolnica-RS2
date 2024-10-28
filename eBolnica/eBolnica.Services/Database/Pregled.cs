using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class Pregled
{
    public int PregledId { get; set; }

    //public int TerminId { get; set; }

    public int UputnicaId { get; set; }

    public string GlavnaDijagnoza { get; set; } = null!;

    public string Anamneza { get; set; } = null!;

    public string Zakljucak { get; set; } = null!;

    public virtual ICollection<Terapija> Terapijas { get; } = new List<Terapija>();

    //public virtual Termin Termin { get; set; } = null!;

    public virtual Uputnica Uputnica { get; set; } = null!;
}
