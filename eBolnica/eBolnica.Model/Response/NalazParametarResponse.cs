using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Response
{
    public class NalazParametarResponse
    {
        public string ImePacijenta { get; set; }
        public string PrezimePacijenta { get; set; }

        public string NazivParametra { get; set; }
        public decimal MinVrijednost { get; set; }
        public decimal MaxVrijednost { get; set; }
        public decimal Vrijednost { get; set; }
    }
}
