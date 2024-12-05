using System;
using System.Collections.Generic;

namespace eBolnica.Model.Models
{

    public partial class OtpusnoPismo
    {
        public int OtpusnoPismoId { get; set; }

        public int? HospitalizacijaId { get; set; }

        public string? Dijagnoza { get; set; }

        public int? TerapijaId { get; set; }

        public string? Anamneza { get; set; }

        public string? Zakljucak { get; set; }

        public virtual Hospitalizacija? Hospitalizacija { get; set; }

        public virtual Terapija? Terapija { get; set; }
    }
}