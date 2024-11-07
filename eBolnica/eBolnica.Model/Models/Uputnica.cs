using System;
using System.Collections.Generic;

namespace eBolnica.Model.Models
{
    public partial class Uputnica
    {
        public int UputnicaId { get; set; }

        public int TerminId { get; set; }
       // public bool? Status { get; set; }
        public DateTime DatumKreiranja { get; set; }
        public string? StateMachine { get; set; }

        public virtual Termin Termin { get; set; } = null!;
    }

}