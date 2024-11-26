using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class Parametar
{
    public int ParametarId { get; set; }

    public string Naziv { get; set; } = null!;

    public decimal MinVrijednost { get; set; }

    public decimal MaxVrijednost { get; set; }

    public virtual ICollection<NalazParametar> NalazParametars { get; } = new List<NalazParametar>();
}
