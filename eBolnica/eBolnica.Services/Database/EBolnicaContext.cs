using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace eBolnica.Services.Database;

public partial class EBolnicaContext : DbContext
{
    public EBolnicaContext()
    {
    }

    public EBolnicaContext(DbContextOptions<EBolnicaContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Administrator> Administrators { get; set; }

    public virtual DbSet<Bolnica> Bolnicas { get; set; }

    public virtual DbSet<Doktor> Doktors { get; set; }

    public virtual DbSet<Hospitalizacija> Hospitalizacijas { get; set; }

    public virtual DbSet<Korisnik> Korisniks { get; set; }

    public virtual DbSet<Krevet> Krevets { get; set; }

    public virtual DbSet<LaboratorijskiNalaz> LaboratorijskiNalazs { get; set; }

    public virtual DbSet<MedicinskaDokumentacija> MedicinskaDokumentacijas { get; set; }

    public virtual DbSet<MedicinskoOsoblje> MedicinskoOsobljes { get; set; }

    public virtual DbSet<NalazParametar> NalazParametars { get; set; }

    public virtual DbSet<Odjel> Odjels { get; set; }

    public virtual DbSet<Operacija> Operacijas { get; set; }

    public virtual DbSet<Pacijent> Pacijents { get; set; }

    public virtual DbSet<Parametar> Parametars { get; set; }

    public virtual DbSet<Pregled> Pregleds { get; set; }

    public virtual DbSet<RadniSati> RadniSatis { get; set; }

    public virtual DbSet<RadniZadatak> RadniZadataks { get; set; }

    public virtual DbSet<RasporedSmjena> RasporedSmjenas { get; set; }

    public virtual DbSet<SlobodniDan> SlobodniDans { get; set; }

    public virtual DbSet<Smjena> Smjenas { get; set; }

    public virtual DbSet<Soba> Sobas { get; set; }

    public virtual DbSet<Status> Statuses { get; set; }

    public virtual DbSet<Terapija> Terapijas { get; set; }

    public virtual DbSet<Termin> Termins { get; set; }

    public virtual DbSet<Uputnica> Uputnicas { get; set; }

    public virtual DbSet<VitalniParametri> VitalniParametris { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Data Source=localhost, 1433;Initial Catalog=eBolnica; user=sa; Password=Mostar123!; TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Administrator>(entity =>
        {
            entity.HasKey(e => e.AdministratorId).HasName("PK__Administ__ACDEFE3340DDBDC7");

            entity.ToTable("Administrator");

            entity.Property(e => e.AdministratorId).HasColumnName("AdministratorID");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Administrators)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Administrator_Korisnik");
        });

        modelBuilder.Entity<Bolnica>(entity =>
        {
            entity.HasKey(e => e.BolnicaId).HasName("PK__Bolnica__CA2F6D62DD0581A2");

            entity.ToTable("Bolnica");

            entity.Property(e => e.BolnicaId).HasColumnName("BolnicaID");
            entity.Property(e => e.Adresa).HasMaxLength(50);
            entity.Property(e => e.Email).HasMaxLength(50);
            entity.Property(e => e.Naziv).HasMaxLength(50);
            entity.Property(e => e.Telefon).HasMaxLength(20);
            entity.Property(e => e.TrenutniBrojHospitalizovanih).HasDefaultValueSql("((0))");
            entity.Property(e => e.UkupanBrojOdjela).HasDefaultValueSql("((0))");
            entity.Property(e => e.UkupanBrojSoba).HasDefaultValueSql("((0))");
        });

        modelBuilder.Entity<Doktor>(entity =>
        {
            entity.HasKey(e => e.DoktorId).HasName("PK__Doktor__77AFB94100FE69BC");

            entity.ToTable("Doktor");

            entity.Property(e => e.DoktorId).HasColumnName("DoktorID");
            entity.Property(e => e.Biografija).HasMaxLength(200);
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.OdjelId).HasColumnName("OdjelID");
            entity.Property(e => e.Specijalizacija).HasMaxLength(50);

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Doktors)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Doktor_Korisnik");

            entity.HasOne(d => d.Odjel).WithMany(p => p.Doktors)
                .HasForeignKey(d => d.OdjelId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Doktor_Odjel");
        });

        modelBuilder.Entity<Hospitalizacija>(entity =>
        {
            entity.HasKey(e => e.HospitalizacijaId).HasName("PK__Hospital__7A4AE91D901D0554");

            entity.ToTable("Hospitalizacija");

            entity.Property(e => e.HospitalizacijaId).HasColumnName("HospitalizacijaID");
            entity.Property(e => e.DatumOtpusta).HasColumnType("date");
            entity.Property(e => e.DatumPrijema).HasColumnType("date");
            entity.Property(e => e.DoktorId).HasColumnName("DoktorID");
            entity.Property(e => e.KrevetId).HasColumnName("KrevetID");
            entity.Property(e => e.OdjelId).HasColumnName("OdjelID");
            entity.Property(e => e.PacijentId).HasColumnName("PacijentID");
            entity.Property(e => e.SobaId).HasColumnName("SobaID");

            entity.HasOne(d => d.Doktor).WithMany(p => p.Hospitalizacijas)
                .HasForeignKey(d => d.DoktorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Hospitalizacija_Doktor");

            entity.HasOne(d => d.Krevet).WithMany(p => p.Hospitalizacijas)
                .HasForeignKey(d => d.KrevetId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Hospitalizacija_Krevet");

            entity.HasOne(d => d.Odjel).WithMany(p => p.Hospitalizacijas)
                .HasForeignKey(d => d.OdjelId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Hospitalizacija_Odjel");

            entity.HasOne(d => d.Pacijent).WithMany(p => p.Hospitalizacijas)
                .HasForeignKey(d => d.PacijentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Hospitalizacija_Pacijent");

            entity.HasOne(d => d.Soba).WithMany(p => p.Hospitalizacijas)
                .HasForeignKey(d => d.SobaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Hospitalizacija_Soba");
        });

        modelBuilder.Entity<Korisnik>(entity =>
        {
            entity.HasKey(e => e.KorisnikId).HasName("PK__Korisnik__80B06D612259F9CD");

            entity.ToTable("Korisnik");

            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.DatumRodjenja).HasColumnType("date");
            entity.Property(e => e.Email).HasMaxLength(50);
            entity.Property(e => e.Ime).HasMaxLength(20);
            entity.Property(e => e.KorisnickoIme).HasMaxLength(50);
            entity.Property(e => e.LozinkaHash).HasMaxLength(50);
            entity.Property(e => e.LozinkaSalt).HasMaxLength(50);
            entity.Property(e => e.Prezime).HasMaxLength(20);
            entity.Property(e => e.Spol).HasMaxLength(8);
            entity.Property(e => e.Telefon).HasMaxLength(20);
        });

        modelBuilder.Entity<Krevet>(entity =>
        {
            entity.HasKey(e => e.KrevetId).HasName("PK__Krevet__E5B7570439B9EDBB");

            entity.ToTable("Krevet");

            entity.Property(e => e.KrevetId).HasColumnName("KrevetID");
            entity.Property(e => e.SobaId).HasColumnName("SobaID");
            entity.Property(e => e.Zauzet).HasDefaultValueSql("((0))");

            entity.HasOne(d => d.Soba).WithMany(p => p.Krevets)
                .HasForeignKey(d => d.SobaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Krevet_Soba");
        });

        modelBuilder.Entity<LaboratorijskiNalaz>(entity =>
        {
            entity.HasKey(e => e.LaboratorijskiNalazId).HasName("PK__Laborato__79773258792B08E7");

            entity.ToTable("LaboratorijskiNalaz");

            entity.Property(e => e.LaboratorijskiNalazId).HasColumnName("LaboratorijskiNalazID");
            entity.Property(e => e.DatumNalaza).HasColumnType("date");
            entity.Property(e => e.DoktorId).HasColumnName("DoktorID");
            entity.Property(e => e.PacijentId).HasColumnName("PacijentID");

            entity.HasOne(d => d.Doktor).WithMany(p => p.LaboratorijskiNalazs)
                .HasForeignKey(d => d.DoktorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_LaboratorijskiNalaz_Doktor");

            entity.HasOne(d => d.Pacijent).WithMany(p => p.LaboratorijskiNalazs)
                .HasForeignKey(d => d.PacijentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_LaboratorijskiNalaz_Pacijent");
        });

        modelBuilder.Entity<MedicinskaDokumentacija>(entity =>
        {
            entity.HasKey(e => e.MedicinskaDokumentacijaId).HasName("PK__Medicins__8FD206224BB5F77C");

            entity.ToTable("MedicinskaDokumentacija");

            entity.Property(e => e.MedicinskaDokumentacijaId).HasColumnName("MedicinskaDokumentacijaID");
            entity.Property(e => e.DatumKreiranja).HasColumnType("datetime");
            entity.Property(e => e.Hospitalizovan).HasDefaultValueSql("((0))");
            entity.Property(e => e.Napomena).HasMaxLength(100);
            entity.Property(e => e.PacijentId).HasColumnName("PacijentID");

            entity.HasOne(d => d.Pacijent).WithMany(p => p.MedicinskaDokumentacijas)
                .HasForeignKey(d => d.PacijentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_MedicinskaDokumentacija_Pacijent");
        });

        modelBuilder.Entity<MedicinskoOsoblje>(entity =>
        {
            entity.HasKey(e => e.MedicinskoOsobljeId).HasName("PK__Medicins__031D4AAD2850DD13");

            entity.ToTable("MedicinskoOsoblje");

            entity.Property(e => e.MedicinskoOsobljeId).HasColumnName("MedicinskoOsobljeID");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.OdjelId).HasColumnName("OdjelID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.MedicinskoOsobljes)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_MedicinskoOsoblje_Korisnik");

            entity.HasOne(d => d.Odjel).WithMany(p => p.MedicinskoOsobljes)
                .HasForeignKey(d => d.OdjelId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_MedicinskoOsoblje_Odjel");
        });

        modelBuilder.Entity<NalazParametar>(entity =>
        {
            entity.HasKey(e => e.NalazParametarId).HasName("PK__NalazPar__1DEE79CBD19A41B1");

            entity.ToTable("NalazParametar");

            entity.Property(e => e.NalazParametarId).HasColumnName("NalazParametarID");
            entity.Property(e => e.LaboratorijskiNalazId).HasColumnName("LaboratorijskiNalazID");
            entity.Property(e => e.ParametarId).HasColumnName("ParametarID");
            entity.Property(e => e.Vrijednost).HasColumnType("decimal(18, 1)");

            entity.HasOne(d => d.LaboratorijskiNalaz).WithMany(p => p.NalazParametars)
                .HasForeignKey(d => d.LaboratorijskiNalazId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_NalazParametar_LaboratorijskiNalaz");

            entity.HasOne(d => d.Parametar).WithMany(p => p.NalazParametars)
                .HasForeignKey(d => d.ParametarId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_NalazParametar_Parametar");
        });

        modelBuilder.Entity<Odjel>(entity =>
        {
            entity.HasKey(e => e.OdjelId).HasName("PK__Odjel__FAE1DA5135ABB2F0");

            entity.ToTable("Odjel");

            entity.Property(e => e.OdjelId).HasColumnName("OdjelID");
            entity.Property(e => e.BolnicaId).HasColumnName("BolnicaID");
            entity.Property(e => e.BrojKreveta).HasDefaultValueSql("((0))");
            entity.Property(e => e.BrojSlobodnihKreveta).HasDefaultValueSql("((0))");
            entity.Property(e => e.BrojSoba).HasDefaultValueSql("((0))");
            entity.Property(e => e.GlavniDoktorId).HasColumnName("GlavniDoktorID");
            entity.Property(e => e.Naziv).HasMaxLength(50);

            entity.HasOne(d => d.Bolnica).WithMany(p => p.Odjels)
                .HasForeignKey(d => d.BolnicaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Odjel_Bolnica");

            entity.HasOne(d => d.GlavniDoktor).WithMany(p => p.Odjels)
                .HasForeignKey(d => d.GlavniDoktorId)
                .HasConstraintName("FK_Odjel_Doktor");
        });

        modelBuilder.Entity<Operacija>(entity =>
        {
            entity.HasKey(e => e.OperacijaId).HasName("PK__Operacij__D0550FAF9FA3E18A");

            entity.ToTable("Operacija");

            entity.Property(e => e.OperacijaId).HasColumnName("OperacijaID");
            entity.Property(e => e.DatumOperacije).HasColumnType("datetime");
            entity.Property(e => e.DoktorId).HasColumnName("DoktorID");
            entity.Property(e => e.Komentar).HasMaxLength(20);
            entity.Property(e => e.PacijentId).HasColumnName("PacijentID");
            entity.Property(e => e.Status).HasMaxLength(20);
            entity.Property(e => e.TerapijaId).HasColumnName("TerapijaID");
            entity.Property(e => e.TipOperacije).HasMaxLength(20);

            entity.HasOne(d => d.Doktor).WithMany(p => p.Operacijas)
                .HasForeignKey(d => d.DoktorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Operacija_Doktor");

            entity.HasOne(d => d.Pacijent).WithMany(p => p.Operacijas)
                .HasForeignKey(d => d.PacijentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Operacija_Pacijent");

            entity.HasOne(d => d.Terapija).WithMany(p => p.Operacijas)
                .HasForeignKey(d => d.TerapijaId)
                .HasConstraintName("FK_Operacija_Terapija");
        });

        modelBuilder.Entity<Pacijent>(entity =>
        {
            entity.HasKey(e => e.PacijentId).HasName("PK__Pacijent__7471C17DA3E8384D");

            entity.ToTable("Pacijent");

            entity.HasIndex(e => e.BrojZdravstveneKartice, "UQ__Pacijent__955F4C606A8B01D1").IsUnique();

            entity.Property(e => e.PacijentId).HasColumnName("PacijentID");
            entity.Property(e => e.Adresa).HasMaxLength(50);
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Pacijents)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Pacijent_Korisnik");
        });

        modelBuilder.Entity<Parametar>(entity =>
        {
            entity.HasKey(e => e.ParametarId).HasName("PK__Parameta__5D50EB242EB9ECB4");

            entity.ToTable("Parametar");

            entity.Property(e => e.ParametarId).HasColumnName("ParametarID");
            entity.Property(e => e.Naziv).HasMaxLength(20);
            entity.Property(e => e.MinVrijednost).HasColumnType("decimal(18, 1)");
            entity.Property(e => e.MaxVrijednost).HasColumnType("decimal(18, 1)");

        });

        modelBuilder.Entity<Pregled>(entity =>
        {
            entity.HasKey(e => e.PregledId).HasName("PK__Pregled__4A8CB6B49155168A");

            entity.ToTable("Pregled");

            entity.Property(e => e.PregledId).HasColumnName("PregledID");
            entity.Property(e => e.Anamneza).HasMaxLength(100);
            entity.Property(e => e.GlavnaDijagnoza).HasMaxLength(100);
            //entity.Property(e => e.TerminId).HasColumnName("TerminID");
            entity.Property(e => e.UputnicaId).HasColumnName("UputnicaID");
            entity.Property(e => e.Zakljucak).HasMaxLength(100);

            //entity.HasOne(d => d.Termin).WithMany(p => p.Pregleds)
            //    .HasForeignKey(d => d.TerminId)
            //    .OnDelete(DeleteBehavior.ClientSetNull)
            //    .HasConstraintName("FK_Pregled_Termin");

            entity.HasOne(d => d.Uputnica).WithMany(p => p.Pregleds)
                .HasForeignKey(d => d.UputnicaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Pregled_Uputnica");
        });

        modelBuilder.Entity<RadniSati>(entity =>
        {
            entity.HasKey(e => e.RadniSatiId).HasName("PK__RadniSat__A39115B27B008C08");

            entity.ToTable("RadniSati");

            entity.Property(e => e.RadniSatiId).HasColumnName("RadniSatiID");
            entity.Property(e => e.MedicinskoOsobljeId).HasColumnName("MedicinskoOsobljeID");
            entity.Property(e => e.RasporedSmjenaId).HasColumnName("RasporedSmjenaID");

            entity.HasOne(d => d.MedicinskoOsoblje).WithMany(p => p.RadniSatis)
                .HasForeignKey(d => d.MedicinskoOsobljeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RadniSati_MedicinskoOsoblje");

            entity.HasOne(d => d.RasporedSmjena).WithMany(p => p.RadniSatis)
                .HasForeignKey(d => d.RasporedSmjenaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RadniSati_RasporedSmjena");
        });

        modelBuilder.Entity<RadniZadatak>(entity =>
        {
            entity.HasKey(e => e.RadniZadatakId).HasName("PK__RadniZad__9E5314D03ED4289A");

            entity.ToTable("RadniZadatak");

            entity.Property(e => e.RadniZadatakId).HasColumnName("RadniZadatakID");
            entity.Property(e => e.DatumZadatka).HasColumnType("datetime");
            entity.Property(e => e.DoktorId).HasColumnName("DoktorID");
            entity.Property(e => e.MedicinskoOsobljeId).HasColumnName("MedicinskoOsobljeID");
            entity.Property(e => e.Opis).HasMaxLength(40);
            entity.Property(e => e.PacijentId).HasColumnName("PacijentID");
            entity.Property(e => e.Status).HasDefaultValueSql("((0))");

            entity.HasOne(d => d.Doktor).WithMany(p => p.RadniZadataks)
                .HasForeignKey(d => d.DoktorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RadniZadatak_Doktor");

            entity.HasOne(d => d.MedicinskoOsoblje).WithMany(p => p.RadniZadataks)
                .HasForeignKey(d => d.MedicinskoOsobljeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RadniZadatak_MedicinskoOsoblje");

            entity.HasOne(d => d.Pacijent).WithMany(p => p.RadniZadataks)
                .HasForeignKey(d => d.PacijentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RadniZadatak_Pacijent");
        });

        modelBuilder.Entity<RasporedSmjena>(entity =>
        {
            entity.HasKey(e => e.RasporedSmjenaId).HasName("PK__Raspored__6199E6F435135DAA");

            entity.ToTable("RasporedSmjena");

            entity.Property(e => e.RasporedSmjenaId).HasColumnName("RasporedSmjenaID");
            entity.Property(e => e.Datum).HasColumnType("date");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.SmjenaId).HasColumnName("SmjenaID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.RasporedSmjenas)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RasporedSmjena_Korisnik");

            entity.HasOne(d => d.Smjena).WithMany(p => p.RasporedSmjenas)
                .HasForeignKey(d => d.SmjenaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RasporedSmjena_Smjena");
        });

        modelBuilder.Entity<SlobodniDan>(entity =>
        {
            entity.HasKey(e => e.SlobodniDanId).HasName("PK__Slobodni__DF3081FE823DEE18");

            entity.ToTable("SlobodniDan");

            entity.Property(e => e.SlobodniDanId).HasColumnName("SlobodniDanID");
            entity.Property(e => e.Datum).HasColumnType("date");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.Razlog).HasMaxLength(40);
            entity.Property(e => e.Status).HasMaxLength(40);

            entity.HasOne(d => d.Korisnik).WithMany(p => p.SlobodniDans)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SlobodniDan_Korisnik");
        });

        modelBuilder.Entity<Smjena>(entity =>
        {
            entity.HasKey(e => e.SmjenaId).HasName("PK__Smjena__26491D9B332B0CE1");

            entity.ToTable("Smjena");

            entity.Property(e => e.SmjenaId).HasColumnName("SmjenaID");
            entity.Property(e => e.NazivSmjene).HasMaxLength(20);
        });

        modelBuilder.Entity<Soba>(entity =>
        {
            entity.HasKey(e => e.SobaId).HasName("PK__Soba__0CDF0AEE2D50BDC6");

            entity.ToTable("Soba");

            entity.Property(e => e.SobaId).HasColumnName("SobaID");
            entity.Property(e => e.BrojKreveta).HasDefaultValueSql("((0))");
            entity.Property(e => e.OdjelId).HasColumnName("OdjelID");
            entity.Property(e => e.Zauzeta).HasDefaultValueSql("((0))");

            entity.HasOne(d => d.Odjel).WithMany(p => p.Sobas)
                .HasForeignKey(d => d.OdjelId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Soba_Odjel");
        });

        modelBuilder.Entity<Status>(entity =>
        {
            entity.HasKey(e => e.StatusId).HasName("PK__Status__C8EE204363BED503");

            entity.ToTable("Status");

            entity.Property(e => e.StatusId).HasColumnName("StatusID");
            entity.Property(e => e.Naziv).HasMaxLength(20);
        });

        modelBuilder.Entity<Terapija>(entity =>
        {
            entity.HasKey(e => e.TerapijaId).HasName("PK__Terapija__0EA553B6B8C13B9F");

            entity.ToTable("Terapija");

            entity.Property(e => e.TerapijaId).HasColumnName("TerapijaID");
            entity.Property(e => e.DatumPocetka).HasColumnType("date");
            entity.Property(e => e.DatumZavrsetka).HasColumnType("date");
            entity.Property(e => e.Naziv).HasMaxLength(50);
            entity.Property(e => e.Opis).HasMaxLength(50);
            entity.Property(e => e.PregledId).HasColumnName("PregledID");

            entity.HasOne(d => d.Pregled).WithMany(p => p.Terapijas)
                .HasForeignKey(d => d.PregledId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("Terapija_Pregled");
        });

        modelBuilder.Entity<Termin>(entity =>
        {
            entity.HasKey(e => e.TerminId).HasName("PK__Termin__42126CB546F72509");

            entity.ToTable("Termin");

            entity.Property(e => e.TerminId).HasColumnName("TerminID");
            entity.Property(e => e.DatumTermina).HasColumnType("date");
            entity.Property(e => e.DoktorId).HasColumnName("DoktorID");
            entity.Property(e => e.OdjelId).HasColumnName("OdjelID");
            entity.Property(e => e.Otkazano).HasDefaultValueSql("((0))");
            entity.Property(e => e.PacijentId).HasColumnName("PacijentID");

            entity.HasOne(d => d.Doktor).WithMany(p => p.Termins)
                .HasForeignKey(d => d.DoktorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Termin_Doktor");

            entity.HasOne(d => d.Odjel).WithMany(p => p.Termins)
                .HasForeignKey(d => d.OdjelId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Termin_Odjel");

            entity.HasOne(d => d.Pacijent).WithMany(p => p.Termins)
                .HasForeignKey(d => d.PacijentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Termin_Pacijent");
        });

        modelBuilder.Entity<Uputnica>(entity =>
        {
            entity.HasKey(e => e.UputnicaId).HasName("PK__Uputnica__B7A9182EABA65D87");

            entity.ToTable("Uputnica");

            entity.Property(e => e.UputnicaId).HasColumnName("UputnicaID");
            entity.Property(e => e.DatumKreiranja).HasColumnType("datetime");
            entity.Property(e => e.StatusId).HasColumnName("StatusID");
            entity.Property(e => e.TerminId).HasColumnName("TerminID");

            entity.HasOne(d => d.Status).WithMany(p => p.Uputnicas)
                .HasForeignKey(d => d.StatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Uputnica_Status");

            entity.HasOne(d => d.Termin).WithMany(p => p.Uputnicas)
                .HasForeignKey(d => d.TerminId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Uputnica_Termin");
        });

        modelBuilder.Entity<VitalniParametri>(entity =>
        {
            entity.HasKey(e => e.VitalniParametarId).HasName("PK__VitalniP__5D42790C8B61FD1B");

            entity.ToTable("VitalniParametri");

            entity.Property(e => e.VitalniParametarId).HasColumnName("VitalniParametarID");
            entity.Property(e => e.DatumMjerenja).HasColumnType("date");
            entity.Property(e => e.PacijentId).HasColumnName("PacijentID");
            entity.Property(e => e.Secer).HasColumnType("decimal(18, 0)");

            entity.HasOne(d => d.Pacijent).WithMany(p => p.VitalniParametris)
                .HasForeignKey(d => d.PacijentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_VitalniParametri_Pacijent");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
