using eBolnica.Services.Interfaces;
using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class Doktor : ISoftDelete
{
    public int DoktorId { get; set; }

    public int KorisnikId { get; set; }

    public int OdjelId { get; set; }

    public string Specijalizacija { get; set; } = null!;

    public string? Biografija { get; set; }
    public bool Obrisano { get; set; }
    public DateTime? VrijemeBrisanja { get; set; }
    public virtual ICollection<Hospitalizacija> Hospitalizacijas { get; } = new List<Hospitalizacija>();

    public virtual Korisnik Korisnik { get; set; } = null!;

    public virtual ICollection<LaboratorijskiNalaz> LaboratorijskiNalazs { get; } = new List<LaboratorijskiNalaz>();

    public virtual Odjel Odjel { get; set; } = null!;

    public virtual ICollection<Odjel> Odjels { get; } = new List<Odjel>();

    public virtual ICollection<Operacija> Operacijas { get; } = new List<Operacija>();

    public virtual ICollection<RadniZadatak> RadniZadataks { get; } = new List<RadniZadatak>();

    public virtual ICollection<Termin> Termins { get; } = new List<Termin>();
}
