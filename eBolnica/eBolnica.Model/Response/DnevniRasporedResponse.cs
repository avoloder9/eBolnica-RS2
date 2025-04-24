using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Response
{
    public class DnevniRasporedResponse
    {
        public int DoktorId { get; set; }
        public DateTime Datum { get; set; }
        public List<Model.Models.Termin> Termini { get; set; } = null!;
        public List<Model.Models.Operacija> Operacije { get; set; } = null!;


    }
}
