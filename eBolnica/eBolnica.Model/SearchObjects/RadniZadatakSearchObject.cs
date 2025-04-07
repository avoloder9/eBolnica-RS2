using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.SearchObjects
{
    public class RadniZadatakSearchObject : BaseSearchObject
    {
        public int? DoktorId { get; set; }
        public int? MedicinskoOsobljeId { get; set; }
        public bool? Status { get; set; }

    }
}
