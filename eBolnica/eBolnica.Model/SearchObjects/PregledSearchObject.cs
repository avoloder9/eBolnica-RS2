using eBolnica.Model.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.SearchObjects
{
    public class PregledSearchObject : BaseSearchObject
    {
        public string? PacijentImeGTE { get; set; }
        public string? PacijentPrezimeGTE { get; set; }
        public string? DoktorImeGTE { get; set; }
        public string? DoktorPrezimeGTE { get; set; }
        public string? NazivOdjela { get; set; }
        public int? DoktorId { get; set; }
    }
}
