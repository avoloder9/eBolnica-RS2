using System;
using System.Collections.Generic;

namespace eBolnica.Model.Models
{
    public partial class Parametar
    {
        public int ParametarId { get; set; }

        public string Naziv { get; set; } = null!;
        public decimal MinVrijednost { get; set; }
        public decimal MaxVrijednost { get; set; }

    }
}