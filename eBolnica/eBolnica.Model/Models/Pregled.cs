using System;
using System.Collections.Generic;

namespace eBolnica.Model.Models
{
    public partial class Pregled
    {
        public int PregledId { get; set; }

        public int UputnicaId { get; set; }

        public string GlavnaDijagnoza { get; set; } = null!;

        public string Anamneza { get; set; } = null!;

        public string Zakljucak { get; set; } = null!;
        public int MedicinskaDokumentacijaId { get; set; }

        public virtual MedicinskaDokumentacija? MedicinskaDokumentacija { get; set; }

        public virtual Uputnica Uputnica { get; set; } = null!;
        public virtual ICollection<Terapija> Terapijas { get; } = new List<Terapija>();

    }
}