﻿using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class ParametarUpdateRequest
    {
        public string Naziv { get; set; } = null!;
        public decimal MinVrijednost { get; set; }
        public decimal MaxVrijednost { get; set; }
    }
}
