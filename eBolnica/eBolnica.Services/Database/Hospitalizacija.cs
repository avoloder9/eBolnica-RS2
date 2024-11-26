using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class Hospitalizacija
{
    public int HospitalizacijaId { get; set; }

    public int PacijentId { get; set; }

    public int DoktorId { get; set; }

    public int OdjelId { get; set; }

    public DateTime DatumPrijema { get; set; }

    public DateTime? DatumOtpusta { get; set; }

    public int SobaId { get; set; }

    public int KrevetId { get; set; }

    public int MedicinskaDokumentacijaId { get; set; }

    public virtual Doktor Doktor { get; set; } = null!;

    public virtual Krevet Krevet { get; set; } = null!;

    public virtual MedicinskaDokumentacija? MedicinskaDokumentacija { get; set; }

    public virtual Odjel Odjel { get; set; } = null!;

    public virtual ICollection<OtpusnoPismo> OtpusnoPismos { get; } = new List<OtpusnoPismo>();

    public virtual Pacijent Pacijent { get; set; } = null!;

    public virtual Soba Soba { get; set; } = null!;
}
