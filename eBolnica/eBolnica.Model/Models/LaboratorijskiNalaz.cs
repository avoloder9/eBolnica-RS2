using System;
using System.Collections.Generic;

namespace eBolnica.Model.Models
{
    public partial class LaboratorijskiNalaz
    {
        public int LaboratorijskiNalazId { get; set; }

        public int PacijentId { get; set; }

        public int DoktorId { get; set; }

        public DateTime DatumNalaza { get; set; }

        public virtual Doktor Doktor { get; set; } = null!;

        public virtual Pacijent Pacijent { get; set; } = null!;
    }
}