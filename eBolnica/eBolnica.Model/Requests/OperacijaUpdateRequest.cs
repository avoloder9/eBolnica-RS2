using eBolnica.Model.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class OperacijaUpdateRequest
    {
        public int DoktorId { get; set; }

        public DateTime DatumOperacije { get; set; }

        public string TipOperacije { get; set; } = null!;

        public string? Komentar { get; set; }

    }
}
