using System;
using System.Collections.Generic;

namespace eBolnica.Model.Models
{
    public partial class Soba
    {
        public int SobaId { get; set; }
        public string Naziv { get; set; }
        public int OdjelId { get; set; }

        public int? BrojKreveta { get; set; }

        public bool? Zauzeta { get; set; }

        public virtual Odjel Odjel { get; set; } = null!;
    }

}