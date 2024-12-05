using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class VitalniParametriUpdateRequest
    {
        public int OtkucajSrca { get; set; }

        public int Saturacija { get; set; }

        public decimal Secer { get; set; }
    }
}
