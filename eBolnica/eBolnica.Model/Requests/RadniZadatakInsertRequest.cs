using eBolnica.Model.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class RadniZadatakInsertRequest
    {
        public int DoktorId { get; set; }

        public int PacijentId { get; set; }

        public int MedicinskoOsobljeId { get; set; }

        public string Opis { get; set; } = null!;

        public DateTime DatumZadatka { get; set; }

        public bool? Status { get; set; }

    }
}
