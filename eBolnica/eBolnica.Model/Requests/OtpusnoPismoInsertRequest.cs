using eBolnica.Model.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class OtpusnoPismoInsertRequest
    {
        public int? HospitalizacijaId { get; set; }

        public string? Dijagnoza { get; set; }

        public int? TerapijaId { get; set; }

        public string? Anamneza { get; set; }

        public string? Zakljucak { get; set; }
    }
}
