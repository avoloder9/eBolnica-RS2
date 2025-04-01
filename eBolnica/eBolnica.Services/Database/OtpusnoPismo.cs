using eBolnica.Services.Interfaces;
using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class OtpusnoPismo : ISoftDelete
{
    public int OtpusnoPismoId { get; set; }

    public int? HospitalizacijaId { get; set; }

    public string? Dijagnoza { get; set; }

    public int? TerapijaId { get; set; }

    public string? Anamneza { get; set; }

    public string? Zakljucak { get; set; }
    public bool Obrisano { get; set; }
    public DateTime? VrijemeBrisanja { get; set; }
    public virtual Hospitalizacija? Hospitalizacija { get; set; }

    public virtual Terapija? Terapija { get; set; }
}
