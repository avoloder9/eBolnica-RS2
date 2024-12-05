using System;
using System.Collections.Generic;

namespace eBolnica.Model.Models
{

    public partial class MedicinskoOsoblje
    {
        public int MedicinskoOsobljeId { get; set; }

        public int KorisnikId { get; set; }

        public int OdjelId { get; set; }

        public virtual Korisnik Korisnik { get; set; } = null!;

        public virtual Odjel Odjel { get; set; } = null!;

    }
}
