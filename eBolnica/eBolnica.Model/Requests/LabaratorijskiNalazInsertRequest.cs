using eBolnica.Model.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class LaboratorijskiNalazInsertRequest
    {
        public DateTime DatumNalaza { get; set; }
        public int PacijentId { get; set; }

        public int DoktorId { get; set; }
    }
}
