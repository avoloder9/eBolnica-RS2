using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class Status
{
    public int StatusId { get; set; }

    public string Naziv { get; set; } = null!;

    public virtual ICollection<Uputnica> Uputnicas { get; } = new List<Uputnica>();
}
