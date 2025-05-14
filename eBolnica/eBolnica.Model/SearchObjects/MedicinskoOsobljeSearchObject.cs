using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.SearchObjects
{
    public class MedicinskoOsobljeSearchObject : BaseSearchObject
    {
        public string? ImeGTE { get; set; }
        public string? PrezimeGTE { get; set; }
        public string? NazivOdjela { get; set; }
        public TimeSpan? VrijemeSmjene { get; set; }
        public DateTime? DatumSmjene { get; set; }

    }
}
