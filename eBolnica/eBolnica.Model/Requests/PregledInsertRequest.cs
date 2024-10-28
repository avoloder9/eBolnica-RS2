using eBolnica.Model.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class PregledInsertRequest
    {

        //public int TerminId { get; set; }

        public int UputnicaId { get; set; }

        public string GlavnaDijagnoza { get; set; } = null!;

        public string Anamneza { get; set; } = null!;

        public string Zakljucak { get; set; } = null!;
    }
}
