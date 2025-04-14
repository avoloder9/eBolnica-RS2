using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Response
{
    public class RecommendedDoktorDTO
    {
        public int DoktorId { get; set; }
        public string Ime { get; set; } = string.Empty;
        public string Prezime { get; set; } = string.Empty;
        public string Specijalizacija { get; set; } = string.Empty;
        public string Biografija { get; set; } = string.Empty;

    }
}
