using eBolnica.Services.Interfaces;
using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class Pacijent : ISoftDelete
{
    public int PacijentId { get; set; }

    public int KorisnikId { get; set; }

    public int BrojZdravstveneKartice { get; set; }

    public string Adresa { get; set; } = null!;

    public int Dob { get; set; }
    public bool Obrisano { get; set; }
    public DateTime? VrijemeBrisanja { get; set; }
    public virtual ICollection<Hospitalizacija> Hospitalizacijas { get; } = new List<Hospitalizacija>();

    public virtual Korisnik Korisnik { get; set; } = null!;

    public virtual ICollection<LaboratorijskiNalaz> LaboratorijskiNalazs { get; } = new List<LaboratorijskiNalaz>();

    public virtual ICollection<MedicinskaDokumentacija> MedicinskaDokumentacijas { get; } = new List<MedicinskaDokumentacija>();

    public virtual ICollection<Operacija> Operacijas { get; } = new List<Operacija>();

    public virtual ICollection<RadniZadatak> RadniZadataks { get; } = new List<RadniZadatak>();

    public virtual ICollection<Termin> Termins { get; } = new List<Termin>();

    public virtual ICollection<VitalniParametri> VitalniParametris { get; } = new List<VitalniParametri>();
}
