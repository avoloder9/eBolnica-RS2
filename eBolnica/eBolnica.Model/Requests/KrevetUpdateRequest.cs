using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class KrevetUpdateRequest
    {
        public int SobaId { get; set; }

        public bool? Zauzet { get; set; }

    }
}
