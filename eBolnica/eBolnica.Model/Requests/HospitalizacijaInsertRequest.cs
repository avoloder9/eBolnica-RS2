using eBolnica.Model.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class HospitalizacijaInsertRequest
    {
        public int PacijentId { get; set; }

        public int DoktorId { get; set; }

        public int OdjelId { get; set; }

        public DateTime DatumPrijema { get; set; }
        public int MedicinskaDokumentacijaId { get; set; }

        public int SobaId { get; set; }

        public int KrevetId { get; set; }
    }
}
