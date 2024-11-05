using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class ParametarInsertRequest
    {
        public string Naziv { get; set; } = null!;
        public decimal MinVrijednost { get; set; }
        public decimal MaxVrijednost { get; set; }
    }
}
