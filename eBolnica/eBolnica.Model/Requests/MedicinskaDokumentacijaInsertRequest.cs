using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class MedicinskaDokumentacijaInsertRequest
    {
        public int PacijentId { get; set; }

        public DateTime? DatumKreiranja { get; set; } = DateTime.Now;

        public bool? Hospitalizovan { get; set; } = false;

        public string? Napomena { get; set; }

    }
}
