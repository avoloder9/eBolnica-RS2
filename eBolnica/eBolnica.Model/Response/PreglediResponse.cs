using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Response
{
    public class PreglediResponse
    {
        public int PregledId { get; set; }
        public int PacijentId { get; set; }
        public string ImeDoktora { get; set; } = null!;
        public string PrezimeDoktora { get; set; } = null!;
        public string ImePacijenta { get; set; } = null!;
        public string PrezimePacijenta { get; set; } = null!;
        public string NazivOdjela { get; set; } = null!;
        public DateTime DatumTermina { get; set; }
        public TimeSpan VrijemeTermina { get; set; }
        public string GlavnaDijagnoza { get; set; } = null!;
        public string Anamneza { get; set; } = null!;
        public string Zakljucak { get; set; } = null!;
    }
}
