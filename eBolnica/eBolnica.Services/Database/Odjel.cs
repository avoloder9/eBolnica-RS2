using eBolnica.Services.Interfaces;
using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class Odjel : ISoftDelete
{
    public int OdjelId { get; set; }

    public string Naziv { get; set; } = null!;

    public int? BrojSoba { get; set; }

    public int? BrojKreveta { get; set; }

    public int? BrojSlobodnihKreveta { get; set; }

    public int BolnicaId { get; set; }

    public int? GlavniDoktorId { get; set; }
    public bool Obrisano { get; set; }
    public DateTime? VrijemeBrisanja { get; set; }
    public virtual Bolnica Bolnica { get; set; } = null!;

    public virtual ICollection<Doktor> Doktors { get; } = new List<Doktor>();

    public virtual Doktor? GlavniDoktor { get; set; }

    public virtual ICollection<Hospitalizacija> Hospitalizacijas { get; } = new List<Hospitalizacija>();

    public virtual ICollection<MedicinskoOsoblje> MedicinskoOsobljes { get; } = new List<MedicinskoOsoblje>();

    public virtual ICollection<Soba> Sobas { get; } = new List<Soba>();

    public virtual ICollection<Termin> Termins { get; } = new List<Termin>();
}
