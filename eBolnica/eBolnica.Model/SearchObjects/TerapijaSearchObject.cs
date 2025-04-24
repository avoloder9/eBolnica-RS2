using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.SearchObjects
{
    public class TerapijaSearchObject : BaseSearchObject
    {
        public int? PacijentId { get; set; }
        public int? PregledId { get; set; }
    }
}
