using eBolnica.Model.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class NalazParametarInsertRequest
    {
        public int LaboratorijskiNalazId { get; set; }

        public int ParametarId { get; set; }

        public decimal Vrijednost { get; set; }
    }
}
