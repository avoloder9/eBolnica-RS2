using eBolnica.Model.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Requests
{
    public class TerapijaInsertRequest
    {

        public string Naziv { get; set; } = null!;

        public string Opis { get; set; } = null!;

        public DateTime DatumPocetka { get; set; }

        public DateTime DatumZavrsetka { get; set; }

        public int PregledId { get; set; }

    }
}
