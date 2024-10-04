using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class MedicinskoOsoblje
{
    public int MedicinskoOsobljeId { get; set; }

    public int KorisnikId { get; set; }

    public int OdjelId { get; set; }

    public virtual Korisnik Korisnik { get; set; } = null!;

    public virtual Odjel Odjel { get; set; } = null!;

    public virtual ICollection<RadniSati> RadniSatis { get; } = new List<RadniSati>();

    public virtual ICollection<RadniZadatak> RadniZadataks { get; } = new List<RadniZadatak>();
}
