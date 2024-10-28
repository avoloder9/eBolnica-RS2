using System;
using System.Collections.Generic;

namespace eBolnica.Model.Models
{
    public partial class Hospitalizacija
    {
        public int HospitalizacijaId { get; set; }

        public int PacijentId { get; set; }

        public int DoktorId { get; set; }

        public int OdjelId { get; set; }

        public DateTime DatumPrijema { get; set; }

        public DateTime? DatumOtpusta { get; set; }

        public int SobaId { get; set; }

        public int KrevetId { get; set; }

        public virtual Doktor Doktor { get; set; } = null!;

        public virtual Krevet Krevet { get; set; } = null!;

        public virtual Odjel Odjel { get; set; } = null!;

        public virtual Pacijent Pacijent { get; set; } = null!;

        public virtual Soba Soba { get; set; } = null!;
    }

}