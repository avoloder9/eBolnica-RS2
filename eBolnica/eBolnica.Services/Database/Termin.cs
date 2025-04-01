using eBolnica.Services.Interfaces;
using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class Termin : ISoftDelete
{
    public int TerminId { get; set; }

    public int PacijentId { get; set; }

    public int DoktorId { get; set; }

    public int OdjelId { get; set; }

    public DateTime DatumTermina { get; set; }

    public TimeSpan VrijemeTermina { get; set; }

    public bool? Otkazano { get; set; }
    public bool Obrisano { get; set; }
    public DateTime? VrijemeBrisanja { get; set; }
    public virtual Doktor Doktor { get; set; } = null!;

    public virtual Odjel Odjel { get; set; } = null!;

    public virtual Pacijent Pacijent { get; set; } = null!;

    public virtual ICollection<Uputnica> Uputnicas { get; } = new List<Uputnica>();
}
