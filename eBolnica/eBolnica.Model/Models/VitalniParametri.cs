using System;
using System.Collections.Generic;

namespace eBolnica.Model.Models
{
    public partial class VitalniParametri
    {
        public int PacijentId { get; set; }

        public int OtkucajSrca { get; set; }

        public int Saturacija { get; set; }

        public decimal Secer { get; set; }

        public DateTime DatumMjerenja { get; set; }
        public TimeSpan VrijemeMjerenja { get; set; }

        public virtual Pacijent Pacijent { get; set; } = null!;
    }

}