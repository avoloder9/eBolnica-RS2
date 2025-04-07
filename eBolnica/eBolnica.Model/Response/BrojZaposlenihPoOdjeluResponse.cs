using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Response
{
    public class BrojZaposlenihPoOdjeluResponse
    {
        public int OdjelId { get; set; }
        public string NazivOdjela { get; set; } = null!;
        public int UkupanBrojZaposlenih { get; set; }
    }
}
