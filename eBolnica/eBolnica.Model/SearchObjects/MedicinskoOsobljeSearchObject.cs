﻿using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.SearchObjects
{
    public class MedicinskoOsobljeSearchObject : BaseSearchObject
    {
        public string? ImeGTE { get; set; }
        public string? PrezimeGTE { get; set; }
    }
}