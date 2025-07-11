﻿using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class SobaInsertRequest
    {
        public int OdjelId { get; set; }
        public string Naziv { get; set; } = null!;

        public int? BrojKreveta { get; set; } = 0;

        public bool? Zauzeta { get; set; } = false;
    }
}
