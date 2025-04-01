using eBolnica.Services.Interfaces;
using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class Korisnik : ISoftDelete
{
    public int KorisnikId { get; set; }

    public string Ime { get; set; } = null!;

    public string Prezime { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string KorisnickoIme { get; set; } = null!;

    public string LozinkaHash { get; set; } = null!;

    public string LozinkaSalt { get; set; } = null!;

    public byte[]? Slika { get; set; }

    public byte[]? SlikaThumb { get; set; }

    public DateTime? DatumRodjenja { get; set; }

    public string? Telefon { get; set; }

    public string? Spol { get; set; }

    public bool Status { get; set; }
    public bool Obrisano { get; set; }
    public DateTime? VrijemeBrisanja { get; set; }
    public virtual ICollection<Administrator> Administrators { get; } = new List<Administrator>();

    public virtual ICollection<Doktor> Doktors { get; } = new List<Doktor>();

    public virtual ICollection<MedicinskoOsoblje> MedicinskoOsobljes { get; } = new List<MedicinskoOsoblje>();

    public virtual ICollection<Pacijent> Pacijents { get; } = new List<Pacijent>();

    public virtual ICollection<RasporedSmjena> RasporedSmjenas { get; } = new List<RasporedSmjena>();

    public virtual ICollection<SlobodniDan> SlobodniDans { get; } = new List<SlobodniDan>();
}
