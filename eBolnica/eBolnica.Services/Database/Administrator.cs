using eBolnica.Services.Interfaces;
using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class Administrator: ISoftDelete
{
    public int AdministratorId { get; set; }

    public int KorisnikId { get; set; }
    public bool Obrisano { get; set; }
    public DateTime? VrijemeBrisanja { get; set; }
    public virtual Korisnik Korisnik { get; set; } = null!;
}
