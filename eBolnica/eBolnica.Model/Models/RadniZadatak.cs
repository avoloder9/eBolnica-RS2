using System;
using System.Collections.Generic;

namespace eBolnica.Model.Models
{
    public partial class RadniZadatak
    {
        public int RadniZadatakId { get; set; }

        public int DoktorId { get; set; }

        public int PacijentId { get; set; }

        public int MedicinskoOsobljeId { get; set; }

        public string Opis { get; set; } = null!;

        public DateTime DatumZadatka { get; set; }

        public bool? Status { get; set; }

        public virtual Doktor Doktor { get; set; } = null!;

        public virtual MedicinskoOsoblje MedicinskoOsoblje { get; set; } = null!;

        public virtual Pacijent Pacijent { get; set; } = null!;
    }

}