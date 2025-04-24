using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Response
{
    public class NalazParametarResponse
    {
        public string ImePacijenta { get; set; } = null!;
        public string PrezimePacijenta { get; set; } = null!;

        public string NazivParametra { get; set; } = null!;
        public decimal MinVrijednost { get; set; }
        public decimal MaxVrijednost { get; set; }
        public decimal Vrijednost { get; set; }
    }
}
