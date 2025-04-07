using eBolnica.Services.Interfaces;
using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class MedicinskoOsoblje : ISoftDelete
{
    public int MedicinskoOsobljeId { get; set; }

    public int KorisnikId { get; set; }

    public int OdjelId { get; set; }

    public virtual Korisnik Korisnik { get; set; } = null!;

    public virtual Odjel Odjel { get; set; } = null!;
    public bool Obrisano { get; set; }
    public DateTime? VrijemeBrisanja { get; set; }
    public virtual ICollection<RadniSati> RadniSatis { get; } = new List<RadniSati>();

    public virtual ICollection<RadniZadatak> RadniZadataks { get; } = new List<RadniZadatak>();
}
