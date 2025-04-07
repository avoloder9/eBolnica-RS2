using eBolnica.Services.Interfaces;
using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class Parametar : ISoftDelete
{
    public int ParametarId { get; set; }

    public string Naziv { get; set; } = null!;

    public decimal MinVrijednost { get; set; }

    public decimal MaxVrijednost { get; set; }
    public bool Obrisano { get; set; }
    public DateTime? VrijemeBrisanja { get; set; }
    public virtual ICollection<NalazParametar> NalazParametars { get; } = new List<NalazParametar>();
}
