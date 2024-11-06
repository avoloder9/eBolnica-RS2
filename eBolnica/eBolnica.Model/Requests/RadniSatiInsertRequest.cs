using eBolnica.Model.Models;
using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace eBolnica.Model.Requests
{
    public class RadniSatiInsertRequest
    {
        public int MedicinskoOsobljeId { get; set; }

        public int RasporedSmjenaId { get; set; }

        public TimeSpan VrijemeDolaska { get; set; }

        public TimeSpan? VrijemeOdlaska { get; set; }

        [JsonIgnore]
        public virtual MedicinskoOsoblje? MedicinskoOsoblje { get; set; } = null!;
    }
}
