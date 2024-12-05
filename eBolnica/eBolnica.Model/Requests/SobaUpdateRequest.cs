using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class SobaUpdateRequest
    {
        public int OdjelId { get; set; }

        public int? BrojKreveta { get; set; }

        public bool? Zauzeta { get; set; } = false;
    }
}
