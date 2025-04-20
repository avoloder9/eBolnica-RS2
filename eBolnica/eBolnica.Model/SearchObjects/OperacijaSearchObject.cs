using eBolnica.Model.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.SearchObjects
{
    public class OperacijaSearchObject : BaseSearchObject
    {
        public string? ImePacijentaGTE { get; set; }
        public string? PrezimePacijentaGTE { get; set; }
        public string? ImeDoktoraGTE { get; set; }
        public string? PrezimeDoktoraGTE { get; set; }
        public int? DoktorId { get; set; }
        public int? PacijentId { get; set; }
    }
}
