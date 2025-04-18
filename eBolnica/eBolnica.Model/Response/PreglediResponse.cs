using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Response
{
    public class PreglediResponse
    {
        public int PregledId { get; set; }
        public int PacijentId { get; set; }
        public string ImeDoktora { get; set; }
        public string PrezimeDoktora { get; set; }
        public string ImePacijenta { get; set; }
        public string PrezimePacijenta { get; set; }
        public string NazivOdjela { get; set; }
        public DateTime DatumTermina { get; set; }
        public TimeSpan VrijemeTermina { get; set; }
        public string GlavnaDijagnoza { get; set; }
        public string Anamneza { get; set; }
        public string Zakljucak { get; set; }
    }
}
