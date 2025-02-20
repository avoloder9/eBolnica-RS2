using eBolnica.Model.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.SearchObjects
{
    public class RasporedSmjenaSearchObject : BaseSearchObject
    {
        public int? SmjenaId { get; set; }
        public DateTime? Datum { get; set; }
        public int OdjelId { get; set; }
    }
}
