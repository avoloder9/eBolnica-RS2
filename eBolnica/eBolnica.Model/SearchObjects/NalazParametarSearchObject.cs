﻿using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.SearchObjects
{
    public class NalazParametarSearchObject : BaseSearchObject
    {
        public string? ImePacijenta { get; set; }
        public string? PrezimePacijenta { get; set; }
        public int? LaboratorijskiNalazId { get; set; }
        public int? HospitalizacijaId { get; set; }

    }
}
