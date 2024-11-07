using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class UputnicaInsertRequest
    {

        public int TerminId { get; set; }

        public bool? Status { get; set; }

        public DateTime DatumKreiranja { get; set; } = DateTime.Now;
    }
}
