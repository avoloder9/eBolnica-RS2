using eBolnica.Services.Interfaces;
using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class MedicinskaDokumentacija : ISoftDelete
{
    public int MedicinskaDokumentacijaId { get; set; }

    public int PacijentId { get; set; }

    public DateTime? DatumKreiranja { get; set; }

    public bool? Hospitalizovan { get; set; }

    public string? Napomena { get; set; }
    public bool Obrisano { get; set; }
    public DateTime? VrijemeBrisanja { get; set; }
    public virtual ICollection<Hospitalizacija> Hospitalizacijas { get; } = new List<Hospitalizacija>();

    public virtual Pacijent Pacijent { get; set; } = null!;

    public virtual ICollection<Pregled> Pregleds { get; } = new List<Pregled>();
}
