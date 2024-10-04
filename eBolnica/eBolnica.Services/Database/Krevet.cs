using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class Krevet
{
    public int KrevetId { get; set; }

    public int SobaId { get; set; }

    public bool? Zauzet { get; set; }

    public virtual ICollection<Hospitalizacija> Hospitalizacijas { get; } = new List<Hospitalizacija>();

    public virtual Soba Soba { get; set; } = null!;
}
