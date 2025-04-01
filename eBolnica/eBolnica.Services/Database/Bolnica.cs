using eBolnica.Services.Interfaces;
using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class Bolnica : ISoftDelete
{
    public int BolnicaId { get; set; }

    public string Naziv { get; set; } = null!;

    public string Adresa { get; set; } = null!;

    public string? Telefon { get; set; }

    public string Email { get; set; } = null!;

    public int? UkupanBrojSoba { get; set; }

    public int? UkupanBrojOdjela { get; set; }
    public int? UkupanBrojKreveta { get; set; }

    public int? TrenutniBrojHospitalizovanih { get; set; }
    public bool Obrisano { get; set; }
    public DateTime? VrijemeBrisanja { get; set; }
    public virtual ICollection<Odjel> Odjels { get; } = new List<Odjel>();
}
