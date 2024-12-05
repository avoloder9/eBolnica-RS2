using eBolnica.Model.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class RadniZadatakUpdateRequest
    {
        public string Opis { get; set; } = null!;
        public bool? Status { get; set; }
    }
}
