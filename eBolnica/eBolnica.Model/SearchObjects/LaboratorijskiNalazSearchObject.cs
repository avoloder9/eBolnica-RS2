using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.SearchObjects
{
    public class LaboratorijskiNalazSearchObject : BaseSearchObject
    {
        public string? ImePacijentaGTE { get; set; }
        public string? PrezimePacijentaGTE { get; set; }
    }
}
