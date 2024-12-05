using System;
using System.Collections.Generic;

namespace eBolnica.Model.Models
{
    public partial class Odjel
    {
        public int OdjelId { get; set; }

        public string Naziv { get; set; } = null!;

        public int? BrojSoba { get; set; }

        public int? BrojKreveta { get; set; }

        public int? BrojSlobodnihKreveta { get; set; }

        public int BolnicaId { get; set; }

        public int? GlavniDoktorId { get; set; }

        public virtual Bolnica Bolnica { get; set; } = null!;

        public virtual Doktor? GlavniDoktor { get; set; }
    }
}