using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.SearchObjects
{
    public class RadniSatiSearchObject : BaseSearchObject
    {
        public int? RasporedSmjenaId { get; set; }
        public bool? AktivneSmjene { get; set; }
    }
}
