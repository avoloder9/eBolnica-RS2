using System;
using System.Collections.Generic;

namespace eBolnica.Model.Models
{
    public partial class Terapija
    {
        public int TerapijaId { get; set; }

        public string Naziv { get; set; } = null!;

        public string Opis { get; set; } = null!;

        public DateTime DatumPocetka { get; set; }

        public DateTime DatumZavrsetka { get; set; }

        public int? PregledId { get; set; }

        public virtual Pregled? Pregled { get; set; } = null!;
    }

}