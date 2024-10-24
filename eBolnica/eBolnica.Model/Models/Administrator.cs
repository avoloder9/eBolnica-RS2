using System;
using System.Collections.Generic;

namespace eBolnica.Model.Models
{
    public partial class Administrator
    {
        public int AdministratorId { get; set; }

        public int KorisnikId { get; set; }

        public virtual Korisnik? Korisnik { get; set; } = null!;
    }
}