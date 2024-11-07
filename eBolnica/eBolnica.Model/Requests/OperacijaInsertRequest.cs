using eBolnica.Model.Models;
using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace eBolnica.Model.Requests
{
    public class OperacijaInsertRequest
    {
        public int PacijentId { get; set; }

        public int DoktorId { get; set; }

        public DateTime DatumOperacije { get; set; }

        public int? TerapijaId { get; set; }

        public string TipOperacije { get; set; } = null!;

        public string? StateMachine { get; set; }

        public string? Komentar { get; set; }

    }
}
