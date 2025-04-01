using eBolnica.Services.Interfaces;
using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class RadniZadatak : ISoftDelete
{
    public int RadniZadatakId { get; set; }

    public int DoktorId { get; set; }

    public int PacijentId { get; set; }

    public int MedicinskoOsobljeId { get; set; }

    public string Opis { get; set; } = null!;

    public DateTime DatumZadatka { get; set; }

    public bool? Status { get; set; }
    public bool Obrisano { get; set; }
    public DateTime? VrijemeBrisanja { get; set; }
    public virtual Doktor Doktor { get; set; } = null!;

    public virtual MedicinskoOsoblje MedicinskoOsoblje { get; set; } = null!;

    public virtual Pacijent Pacijent { get; set; } = null!;
}
