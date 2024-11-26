using eBolnica.Model.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class PregledInsertRequest
    {

      

        public int UputnicaId { get; set; }
        public int MedicinskaDokumentacijaId { get; set; }

        public string GlavnaDijagnoza { get; set; } = null!;

        public string Anamneza { get; set; } = null!;

        public string Zakljucak { get; set; } = null!;
    }
}
