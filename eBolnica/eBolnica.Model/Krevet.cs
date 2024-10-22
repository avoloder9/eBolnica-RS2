using System;
using System.Collections.Generic;

namespace eBolnica.Model
{

    public partial class Krevet
    {
        public int KrevetId { get; set; }

        public int SobaId { get; set; }

        public bool? Zauzet { get; set; }

        public virtual Soba Soba { get; set; } = null!;
    }
}