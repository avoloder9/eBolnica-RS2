using eBolnica.Services.Interfaces;
using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class Pregled : ISoftDelete
{
    public int PregledId { get; set; }

    public int UputnicaId { get; set; }

    public string GlavnaDijagnoza { get; set; } = null!;

    public string Anamneza { get; set; } = null!;

    public string Zakljucak { get; set; } = null!;

    public int MedicinskaDokumentacijaId { get; set; }
    public bool Obrisano { get; set; }
    public DateTime? VrijemeBrisanja { get; set; }
    public virtual MedicinskaDokumentacija? MedicinskaDokumentacija { get; set; }

    public virtual ICollection<Terapija> Terapijas { get; } = new List<Terapija>();

    public virtual Uputnica Uputnica { get; set; } = null!;
}
