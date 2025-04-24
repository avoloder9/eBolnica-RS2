using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.SearchObjects
{
    public class TerminSearchObject : BaseSearchObject
    {
        public int? DoktorId { get; set; }
        public int? OdjelId { get; set; }
        public int? PacijentId { get; set; }

    }
}
