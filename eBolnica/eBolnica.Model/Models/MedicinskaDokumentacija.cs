using System;
using System.Collections.Generic;

namespace eBolnica.Model.Models
{
    public partial class MedicinskaDokumentacija
    {
        public int MedicinskaDokumentacijaId { get; set; }

        public int PacijentId { get; set; }

        public DateTime? DatumKreiranja { get; set; }

        public bool? Hospitalizovan { get; set; }

        public string? Napomena { get; set; }

        public virtual Pacijent Pacijent { get; set; } = null!;
    }
}