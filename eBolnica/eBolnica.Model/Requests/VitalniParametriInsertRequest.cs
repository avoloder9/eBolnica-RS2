using eBolnica.Model.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class VitalniParametriInsertRequest
    {
        public int PacijentId { get; set; }

        public int OtkucajSrca { get; set; }

        public int Saturacija { get; set; }

        public decimal Secer { get; set; }

        public DateTime DatumMjerenja { get; set; } = DateTime.Now;
        public TimeSpan VrijemeMjerenja { get; set; }
    }
}
