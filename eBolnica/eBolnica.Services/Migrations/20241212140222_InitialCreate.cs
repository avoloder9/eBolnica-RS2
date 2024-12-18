using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eBolnica.Services.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Bolnica",
                columns: table => new
                {
                    BolnicaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Adresa = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Telefon = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true),
                    Email = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    UkupanBrojSoba = table.Column<int>(type: "int", nullable: true, defaultValueSql: "((0))"),
                    UkupanBrojOdjela = table.Column<int>(type: "int", nullable: true, defaultValueSql: "((0))"),
                    UkupanBrojKreveta = table.Column<int>(type: "int", nullable: true, defaultValueSql: "((0))"),
                    TrenutniBrojHospitalizovanih = table.Column<int>(type: "int", nullable: true, defaultValueSql: "((0))")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Bolnica__CA2F6D62DD0581A2", x => x.BolnicaID);
                });

            migrationBuilder.CreateTable(
                name: "Korisnik",
                columns: table => new
                {
                    KorisnikID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Ime = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    Prezime = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    KorisnickoIme = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    LozinkaHash = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    LozinkaSalt = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    SlikaThumb = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    DatumRodjenja = table.Column<DateTime>(type: "date", nullable: true),
                    Telefon = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true),
                    Spol = table.Column<string>(type: "nvarchar(8)", maxLength: 8, nullable: true),
                    Status = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Korisnik__80B06D612259F9CD", x => x.KorisnikID);
                });

            migrationBuilder.CreateTable(
                name: "Parametar",
                columns: table => new
                {
                    ParametarID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    MinVrijednost = table.Column<decimal>(type: "decimal(18,1)", nullable: false),
                    MaxVrijednost = table.Column<decimal>(type: "decimal(18,1)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Parameta__5D50EB242EB9ECB4", x => x.ParametarID);
                });

            migrationBuilder.CreateTable(
                name: "Smjena",
                columns: table => new
                {
                    SmjenaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NazivSmjene = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true),
                    VrijemePocetka = table.Column<TimeSpan>(type: "time", nullable: false),
                    VrijemeZavrsetka = table.Column<TimeSpan>(type: "time", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Smjena__26491D9B332B0CE1", x => x.SmjenaID);
                });

            migrationBuilder.CreateTable(
                name: "Administrator",
                columns: table => new
                {
                    AdministratorID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Administ__ACDEFE3340DDBDC7", x => x.AdministratorID);
                    table.ForeignKey(
                        name: "FK_Administrator_Korisnik",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikID");
                });

            migrationBuilder.CreateTable(
                name: "Pacijent",
                columns: table => new
                {
                    PacijentID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikID = table.Column<int>(type: "int", nullable: false),
                    BrojZdravstveneKartice = table.Column<int>(type: "int", nullable: false),
                    Adresa = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Dob = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Pacijent__7471C17DA3E8384D", x => x.PacijentID);
                    table.ForeignKey(
                        name: "FK_Pacijent_Korisnik",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikID");
                });

            migrationBuilder.CreateTable(
                name: "SlobodniDan",
                columns: table => new
                {
                    SlobodniDanID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikID = table.Column<int>(type: "int", nullable: false),
                    Datum = table.Column<DateTime>(type: "date", nullable: false),
                    Razlog = table.Column<string>(type: "nvarchar(40)", maxLength: 40, nullable: false),
                    Status = table.Column<bool>(type: "bit", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Slobodni__DF3081FE823DEE18", x => x.SlobodniDanID);
                    table.ForeignKey(
                        name: "FK_SlobodniDan_Korisnik",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikID");
                });

            migrationBuilder.CreateTable(
                name: "RasporedSmjena",
                columns: table => new
                {
                    RasporedSmjenaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    SmjenaID = table.Column<int>(type: "int", nullable: false),
                    KorisnikID = table.Column<int>(type: "int", nullable: false),
                    Datum = table.Column<DateTime>(type: "date", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Raspored__6199E6F435135DAA", x => x.RasporedSmjenaID);
                    table.ForeignKey(
                        name: "FK_RasporedSmjena_Korisnik",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikID");
                    table.ForeignKey(
                        name: "FK_RasporedSmjena_Smjena",
                        column: x => x.SmjenaID,
                        principalTable: "Smjena",
                        principalColumn: "SmjenaID");
                });

            migrationBuilder.CreateTable(
                name: "MedicinskaDokumentacija",
                columns: table => new
                {
                    MedicinskaDokumentacijaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PacijentID = table.Column<int>(type: "int", nullable: false),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime", nullable: true),
                    Hospitalizovan = table.Column<bool>(type: "bit", nullable: true, defaultValueSql: "((0))"),
                    Napomena = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Medicins__8FD206224BB5F77C", x => x.MedicinskaDokumentacijaID);
                    table.ForeignKey(
                        name: "FK_MedicinskaDokumentacija_Pacijent",
                        column: x => x.PacijentID,
                        principalTable: "Pacijent",
                        principalColumn: "PacijentID");
                });

            migrationBuilder.CreateTable(
                name: "VitalniParametri",
                columns: table => new
                {
                    VitalniParametarID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PacijentID = table.Column<int>(type: "int", nullable: false),
                    OtkucajSrca = table.Column<int>(type: "int", nullable: false),
                    Saturacija = table.Column<int>(type: "int", nullable: false),
                    Secer = table.Column<decimal>(type: "decimal(18,0)", nullable: false),
                    DatumMjerenja = table.Column<DateTime>(type: "date", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__VitalniP__5D42790C8B61FD1B", x => x.VitalniParametarID);
                    table.ForeignKey(
                        name: "FK_VitalniParametri_Pacijent",
                        column: x => x.PacijentID,
                        principalTable: "Pacijent",
                        principalColumn: "PacijentID");
                });

            migrationBuilder.CreateTable(
                name: "Doktor",
                columns: table => new
                {
                    DoktorID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikID = table.Column<int>(type: "int", nullable: false),
                    OdjelID = table.Column<int>(type: "int", nullable: false),
                    Specijalizacija = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Biografija = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Doktor__77AFB94100FE69BC", x => x.DoktorID);
                    table.ForeignKey(
                        name: "FK_Doktor_Korisnik",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikID");
                });

            migrationBuilder.CreateTable(
                name: "LaboratorijskiNalaz",
                columns: table => new
                {
                    LaboratorijskiNalazID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PacijentID = table.Column<int>(type: "int", nullable: false),
                    DoktorID = table.Column<int>(type: "int", nullable: false),
                    DatumNalaza = table.Column<DateTime>(type: "date", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Laborato__79773258792B08E7", x => x.LaboratorijskiNalazID);
                    table.ForeignKey(
                        name: "FK_LaboratorijskiNalaz_Doktor",
                        column: x => x.DoktorID,
                        principalTable: "Doktor",
                        principalColumn: "DoktorID");
                    table.ForeignKey(
                        name: "FK_LaboratorijskiNalaz_Pacijent",
                        column: x => x.PacijentID,
                        principalTable: "Pacijent",
                        principalColumn: "PacijentID");
                });

            migrationBuilder.CreateTable(
                name: "Odjel",
                columns: table => new
                {
                    OdjelID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    BrojSoba = table.Column<int>(type: "int", nullable: true, defaultValueSql: "((0))"),
                    BrojKreveta = table.Column<int>(type: "int", nullable: true, defaultValueSql: "((0))"),
                    BrojSlobodnihKreveta = table.Column<int>(type: "int", nullable: true, defaultValueSql: "((0))"),
                    BolnicaID = table.Column<int>(type: "int", nullable: false),
                    GlavniDoktorID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Odjel__FAE1DA5135ABB2F0", x => x.OdjelID);
                    table.ForeignKey(
                        name: "FK_Odjel_Bolnica",
                        column: x => x.BolnicaID,
                        principalTable: "Bolnica",
                        principalColumn: "BolnicaID");
                    table.ForeignKey(
                        name: "FK_Odjel_Doktor",
                        column: x => x.GlavniDoktorID,
                        principalTable: "Doktor",
                        principalColumn: "DoktorID");
                });

            migrationBuilder.CreateTable(
                name: "NalazParametar",
                columns: table => new
                {
                    NalazParametarID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    LaboratorijskiNalazID = table.Column<int>(type: "int", nullable: false),
                    ParametarID = table.Column<int>(type: "int", nullable: false),
                    Vrijednost = table.Column<decimal>(type: "decimal(18,1)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__NalazPar__1DEE79CBD19A41B1", x => x.NalazParametarID);
                    table.ForeignKey(
                        name: "FK_NalazParametar_LaboratorijskiNalaz",
                        column: x => x.LaboratorijskiNalazID,
                        principalTable: "LaboratorijskiNalaz",
                        principalColumn: "LaboratorijskiNalazID");
                    table.ForeignKey(
                        name: "FK_NalazParametar_Parametar",
                        column: x => x.ParametarID,
                        principalTable: "Parametar",
                        principalColumn: "ParametarID");
                });

            migrationBuilder.CreateTable(
                name: "MedicinskoOsoblje",
                columns: table => new
                {
                    MedicinskoOsobljeID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikID = table.Column<int>(type: "int", nullable: false),
                    OdjelID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Medicins__031D4AAD2850DD13", x => x.MedicinskoOsobljeID);
                    table.ForeignKey(
                        name: "FK_MedicinskoOsoblje_Korisnik",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikID");
                    table.ForeignKey(
                        name: "FK_MedicinskoOsoblje_Odjel",
                        column: x => x.OdjelID,
                        principalTable: "Odjel",
                        principalColumn: "OdjelID");
                });

            migrationBuilder.CreateTable(
                name: "Soba",
                columns: table => new
                {
                    SobaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    OdjelID = table.Column<int>(type: "int", nullable: false),
                    BrojKreveta = table.Column<int>(type: "int", nullable: true, defaultValueSql: "((0))"),
                    Zauzeta = table.Column<bool>(type: "bit", nullable: true, defaultValueSql: "((0))")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Soba__0CDF0AEE2D50BDC6", x => x.SobaID);
                    table.ForeignKey(
                        name: "FK_Soba_Odjel",
                        column: x => x.OdjelID,
                        principalTable: "Odjel",
                        principalColumn: "OdjelID");
                });

            migrationBuilder.CreateTable(
                name: "Termin",
                columns: table => new
                {
                    TerminID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PacijentID = table.Column<int>(type: "int", nullable: false),
                    DoktorID = table.Column<int>(type: "int", nullable: false),
                    OdjelID = table.Column<int>(type: "int", nullable: false),
                    DatumTermina = table.Column<DateTime>(type: "date", nullable: false),
                    VrijemeTermina = table.Column<TimeSpan>(type: "time", nullable: false),
                    Otkazano = table.Column<bool>(type: "bit", nullable: true, defaultValueSql: "((0))")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Termin__42126CB546F72509", x => x.TerminID);
                    table.ForeignKey(
                        name: "FK_Termin_Doktor",
                        column: x => x.DoktorID,
                        principalTable: "Doktor",
                        principalColumn: "DoktorID");
                    table.ForeignKey(
                        name: "FK_Termin_Odjel",
                        column: x => x.OdjelID,
                        principalTable: "Odjel",
                        principalColumn: "OdjelID");
                    table.ForeignKey(
                        name: "FK_Termin_Pacijent",
                        column: x => x.PacijentID,
                        principalTable: "Pacijent",
                        principalColumn: "PacijentID");
                });

            migrationBuilder.CreateTable(
                name: "RadniSati",
                columns: table => new
                {
                    RadniSatiID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    MedicinskoOsobljeID = table.Column<int>(type: "int", nullable: false),
                    RasporedSmjenaID = table.Column<int>(type: "int", nullable: false),
                    VrijemeDolaska = table.Column<TimeSpan>(type: "time", nullable: false),
                    VrijemeOdlaska = table.Column<TimeSpan>(type: "time", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__RadniSat__A39115B27B008C08", x => x.RadniSatiID);
                    table.ForeignKey(
                        name: "FK_RadniSati_MedicinskoOsoblje",
                        column: x => x.MedicinskoOsobljeID,
                        principalTable: "MedicinskoOsoblje",
                        principalColumn: "MedicinskoOsobljeID");
                    table.ForeignKey(
                        name: "FK_RadniSati_RasporedSmjena",
                        column: x => x.RasporedSmjenaID,
                        principalTable: "RasporedSmjena",
                        principalColumn: "RasporedSmjenaID");
                });

            migrationBuilder.CreateTable(
                name: "RadniZadatak",
                columns: table => new
                {
                    RadniZadatakID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DoktorID = table.Column<int>(type: "int", nullable: false),
                    PacijentID = table.Column<int>(type: "int", nullable: false),
                    MedicinskoOsobljeID = table.Column<int>(type: "int", nullable: false),
                    Opis = table.Column<string>(type: "nvarchar(40)", maxLength: 40, nullable: false),
                    DatumZadatka = table.Column<DateTime>(type: "datetime", nullable: false),
                    Status = table.Column<bool>(type: "bit", nullable: true, defaultValueSql: "((0))")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__RadniZad__9E5314D03ED4289A", x => x.RadniZadatakID);
                    table.ForeignKey(
                        name: "FK_RadniZadatak_Doktor",
                        column: x => x.DoktorID,
                        principalTable: "Doktor",
                        principalColumn: "DoktorID");
                    table.ForeignKey(
                        name: "FK_RadniZadatak_MedicinskoOsoblje",
                        column: x => x.MedicinskoOsobljeID,
                        principalTable: "MedicinskoOsoblje",
                        principalColumn: "MedicinskoOsobljeID");
                    table.ForeignKey(
                        name: "FK_RadniZadatak_Pacijent",
                        column: x => x.PacijentID,
                        principalTable: "Pacijent",
                        principalColumn: "PacijentID");
                });

            migrationBuilder.CreateTable(
                name: "Krevet",
                columns: table => new
                {
                    KrevetID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    SobaID = table.Column<int>(type: "int", nullable: false),
                    Zauzet = table.Column<bool>(type: "bit", nullable: false, defaultValueSql: "((0))")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Krevet__E5B7570439B9EDBB", x => x.KrevetID);
                    table.ForeignKey(
                        name: "FK_Krevet_Soba",
                        column: x => x.SobaID,
                        principalTable: "Soba",
                        principalColumn: "SobaID");
                });

            migrationBuilder.CreateTable(
                name: "Uputnica",
                columns: table => new
                {
                    UputnicaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    TerminID = table.Column<int>(type: "int", nullable: false),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime", nullable: false),
                    Status = table.Column<bool>(type: "bit", nullable: false),
                    StateMachine = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Uputnica__B7A9182EABA65D87", x => x.UputnicaID);
                    table.ForeignKey(
                        name: "FK_Uputnica_Termin",
                        column: x => x.TerminID,
                        principalTable: "Termin",
                        principalColumn: "TerminID");
                });

            migrationBuilder.CreateTable(
                name: "Hospitalizacija",
                columns: table => new
                {
                    HospitalizacijaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PacijentID = table.Column<int>(type: "int", nullable: false),
                    DoktorID = table.Column<int>(type: "int", nullable: false),
                    OdjelID = table.Column<int>(type: "int", nullable: false),
                    DatumPrijema = table.Column<DateTime>(type: "date", nullable: false),
                    DatumOtpusta = table.Column<DateTime>(type: "date", nullable: true),
                    SobaID = table.Column<int>(type: "int", nullable: false),
                    KrevetID = table.Column<int>(type: "int", nullable: false),
                    MedicinskaDokumentacijaID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Hospital__7A4AE91D901D0554", x => x.HospitalizacijaID);
                    table.ForeignKey(
                        name: "FK_Hospitalizacija_Doktor",
                        column: x => x.DoktorID,
                        principalTable: "Doktor",
                        principalColumn: "DoktorID");
                    table.ForeignKey(
                        name: "FK_Hospitalizacija_Krevet",
                        column: x => x.KrevetID,
                        principalTable: "Krevet",
                        principalColumn: "KrevetID");
                    table.ForeignKey(
                        name: "FK_Hospitalizacija_Odjel",
                        column: x => x.OdjelID,
                        principalTable: "Odjel",
                        principalColumn: "OdjelID");
                    table.ForeignKey(
                        name: "FK_Hospitalizacija_Pacijent",
                        column: x => x.PacijentID,
                        principalTable: "Pacijent",
                        principalColumn: "PacijentID");
                    table.ForeignKey(
                        name: "FK_Hospitalizacija_Soba",
                        column: x => x.SobaID,
                        principalTable: "Soba",
                        principalColumn: "SobaID");
                    table.ForeignKey(
                        name: "FK__Hospitali__Medic__5224328E",
                        column: x => x.MedicinskaDokumentacijaID,
                        principalTable: "MedicinskaDokumentacija",
                        principalColumn: "MedicinskaDokumentacijaID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Pregled",
                columns: table => new
                {
                    PregledID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UputnicaID = table.Column<int>(type: "int", nullable: false),
                    GlavnaDijagnoza = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Anamneza = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Zakljucak = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    MedicinskaDokumentacijaID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Pregled__4A8CB6B49155168A", x => x.PregledID);
                    table.ForeignKey(
                        name: "FK_Pregled_Uputnica",
                        column: x => x.UputnicaID,
                        principalTable: "Uputnica",
                        principalColumn: "UputnicaID");
                    table.ForeignKey(
                        name: "FK__Pregled__Medicin__51300E55",
                        column: x => x.MedicinskaDokumentacijaID,
                        principalTable: "MedicinskaDokumentacija",
                        principalColumn: "MedicinskaDokumentacijaID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Terapija",
                columns: table => new
                {
                    TerapijaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Opis = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    DatumPocetka = table.Column<DateTime>(type: "date", nullable: false),
                    DatumZavrsetka = table.Column<DateTime>(type: "date", nullable: false),
                    PregledID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Terapija__0EA553B6B8C13B9F", x => x.TerapijaID);
                    table.ForeignKey(
                        name: "Terapija_Pregled",
                        column: x => x.PregledID,
                        principalTable: "Pregled",
                        principalColumn: "PregledID");
                });

            migrationBuilder.CreateTable(
                name: "Operacija",
                columns: table => new
                {
                    OperacijaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PacijentID = table.Column<int>(type: "int", nullable: false),
                    DoktorID = table.Column<int>(type: "int", nullable: false),
                    DatumOperacije = table.Column<DateTime>(type: "datetime", nullable: false),
                    TerapijaID = table.Column<int>(type: "int", nullable: true),
                    TipOperacije = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    StateMachine = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true),
                    Komentar = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Operacij__D0550FAF9FA3E18A", x => x.OperacijaID);
                    table.ForeignKey(
                        name: "FK_Operacija_Doktor",
                        column: x => x.DoktorID,
                        principalTable: "Doktor",
                        principalColumn: "DoktorID");
                    table.ForeignKey(
                        name: "FK_Operacija_Pacijent",
                        column: x => x.PacijentID,
                        principalTable: "Pacijent",
                        principalColumn: "PacijentID");
                    table.ForeignKey(
                        name: "FK_Operacija_Terapija",
                        column: x => x.TerapijaID,
                        principalTable: "Terapija",
                        principalColumn: "TerapijaID");
                });

            migrationBuilder.CreateTable(
                name: "OtpusnoPismo",
                columns: table => new
                {
                    OtpusnoPismoID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    HospitalizacijaID = table.Column<int>(type: "int", nullable: true),
                    Dijagnoza = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    TerapijaID = table.Column<int>(type: "int", nullable: true),
                    Anamneza = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Zakljucak = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__OtpusnoP__3A85962A9D508918", x => x.OtpusnoPismoID);
                    table.ForeignKey(
                        name: "FK__OtpusnoPi__Hospi__4F47C5E3",
                        column: x => x.HospitalizacijaID,
                        principalTable: "Hospitalizacija",
                        principalColumn: "HospitalizacijaID");
                    table.ForeignKey(
                        name: "FK__OtpusnoPi__Terap__503BEA1C",
                        column: x => x.TerapijaID,
                        principalTable: "Terapija",
                        principalColumn: "TerapijaID");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Administrator_KorisnikID",
                table: "Administrator",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Doktor_KorisnikID",
                table: "Doktor",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Doktor_OdjelID",
                table: "Doktor",
                column: "OdjelID");

            migrationBuilder.CreateIndex(
                name: "IX_Hospitalizacija_DoktorID",
                table: "Hospitalizacija",
                column: "DoktorID");

            migrationBuilder.CreateIndex(
                name: "IX_Hospitalizacija_KrevetID",
                table: "Hospitalizacija",
                column: "KrevetID");

            migrationBuilder.CreateIndex(
                name: "IX_Hospitalizacija_MedicinskaDokumentacijaID",
                table: "Hospitalizacija",
                column: "MedicinskaDokumentacijaID");

            migrationBuilder.CreateIndex(
                name: "IX_Hospitalizacija_OdjelID",
                table: "Hospitalizacija",
                column: "OdjelID");

            migrationBuilder.CreateIndex(
                name: "IX_Hospitalizacija_PacijentID",
                table: "Hospitalizacija",
                column: "PacijentID");

            migrationBuilder.CreateIndex(
                name: "IX_Hospitalizacija_SobaID",
                table: "Hospitalizacija",
                column: "SobaID");

            migrationBuilder.CreateIndex(
                name: "IX_Krevet_SobaID",
                table: "Krevet",
                column: "SobaID");

            migrationBuilder.CreateIndex(
                name: "IX_LaboratorijskiNalaz_DoktorID",
                table: "LaboratorijskiNalaz",
                column: "DoktorID");

            migrationBuilder.CreateIndex(
                name: "IX_LaboratorijskiNalaz_PacijentID",
                table: "LaboratorijskiNalaz",
                column: "PacijentID");

            migrationBuilder.CreateIndex(
                name: "IX_MedicinskaDokumentacija_PacijentID",
                table: "MedicinskaDokumentacija",
                column: "PacijentID");

            migrationBuilder.CreateIndex(
                name: "IX_MedicinskoOsoblje_KorisnikID",
                table: "MedicinskoOsoblje",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_MedicinskoOsoblje_OdjelID",
                table: "MedicinskoOsoblje",
                column: "OdjelID");

            migrationBuilder.CreateIndex(
                name: "IX_NalazParametar_LaboratorijskiNalazID",
                table: "NalazParametar",
                column: "LaboratorijskiNalazID");

            migrationBuilder.CreateIndex(
                name: "IX_NalazParametar_ParametarID",
                table: "NalazParametar",
                column: "ParametarID");

            migrationBuilder.CreateIndex(
                name: "IX_Odjel_BolnicaID",
                table: "Odjel",
                column: "BolnicaID");

            migrationBuilder.CreateIndex(
                name: "IX_Odjel_GlavniDoktorID",
                table: "Odjel",
                column: "GlavniDoktorID");

            migrationBuilder.CreateIndex(
                name: "IX_Operacija_DoktorID",
                table: "Operacija",
                column: "DoktorID");

            migrationBuilder.CreateIndex(
                name: "IX_Operacija_PacijentID",
                table: "Operacija",
                column: "PacijentID");

            migrationBuilder.CreateIndex(
                name: "IX_Operacija_TerapijaID",
                table: "Operacija",
                column: "TerapijaID");

            migrationBuilder.CreateIndex(
                name: "IX_OtpusnoPismo_HospitalizacijaID",
                table: "OtpusnoPismo",
                column: "HospitalizacijaID");

            migrationBuilder.CreateIndex(
                name: "IX_OtpusnoPismo_TerapijaID",
                table: "OtpusnoPismo",
                column: "TerapijaID");

            migrationBuilder.CreateIndex(
                name: "IX_Pacijent_KorisnikID",
                table: "Pacijent",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "UQ__Pacijent__955F4C606A8B01D1",
                table: "Pacijent",
                column: "BrojZdravstveneKartice",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Pregled_MedicinskaDokumentacijaID",
                table: "Pregled",
                column: "MedicinskaDokumentacijaID");

            migrationBuilder.CreateIndex(
                name: "IX_Pregled_UputnicaID",
                table: "Pregled",
                column: "UputnicaID");

            migrationBuilder.CreateIndex(
                name: "IX_RadniSati_MedicinskoOsobljeID",
                table: "RadniSati",
                column: "MedicinskoOsobljeID");

            migrationBuilder.CreateIndex(
                name: "IX_RadniSati_RasporedSmjenaID",
                table: "RadniSati",
                column: "RasporedSmjenaID");

            migrationBuilder.CreateIndex(
                name: "IX_RadniZadatak_DoktorID",
                table: "RadniZadatak",
                column: "DoktorID");

            migrationBuilder.CreateIndex(
                name: "IX_RadniZadatak_MedicinskoOsobljeID",
                table: "RadniZadatak",
                column: "MedicinskoOsobljeID");

            migrationBuilder.CreateIndex(
                name: "IX_RadniZadatak_PacijentID",
                table: "RadniZadatak",
                column: "PacijentID");

            migrationBuilder.CreateIndex(
                name: "IX_RasporedSmjena_KorisnikID",
                table: "RasporedSmjena",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_RasporedSmjena_SmjenaID",
                table: "RasporedSmjena",
                column: "SmjenaID");

            migrationBuilder.CreateIndex(
                name: "IX_SlobodniDan_KorisnikID",
                table: "SlobodniDan",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Soba_OdjelID",
                table: "Soba",
                column: "OdjelID");

            migrationBuilder.CreateIndex(
                name: "IX_Terapija_PregledID",
                table: "Terapija",
                column: "PregledID");

            migrationBuilder.CreateIndex(
                name: "IX_Termin_DoktorID",
                table: "Termin",
                column: "DoktorID");

            migrationBuilder.CreateIndex(
                name: "IX_Termin_OdjelID",
                table: "Termin",
                column: "OdjelID");

            migrationBuilder.CreateIndex(
                name: "IX_Termin_PacijentID",
                table: "Termin",
                column: "PacijentID");

            migrationBuilder.CreateIndex(
                name: "IX_Uputnica_TerminID",
                table: "Uputnica",
                column: "TerminID");

            migrationBuilder.CreateIndex(
                name: "IX_VitalniParametri_PacijentID",
                table: "VitalniParametri",
                column: "PacijentID");

            migrationBuilder.AddForeignKey(
                name: "FK_Doktor_Odjel",
                table: "Doktor",
                column: "OdjelID",
                principalTable: "Odjel",
                principalColumn: "OdjelID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Doktor_Korisnik",
                table: "Doktor");

            migrationBuilder.DropForeignKey(
                name: "FK_Doktor_Odjel",
                table: "Doktor");

            migrationBuilder.DropTable(
                name: "Administrator");

            migrationBuilder.DropTable(
                name: "NalazParametar");

            migrationBuilder.DropTable(
                name: "Operacija");

            migrationBuilder.DropTable(
                name: "OtpusnoPismo");

            migrationBuilder.DropTable(
                name: "RadniSati");

            migrationBuilder.DropTable(
                name: "RadniZadatak");

            migrationBuilder.DropTable(
                name: "SlobodniDan");

            migrationBuilder.DropTable(
                name: "VitalniParametri");

            migrationBuilder.DropTable(
                name: "LaboratorijskiNalaz");

            migrationBuilder.DropTable(
                name: "Parametar");

            migrationBuilder.DropTable(
                name: "Hospitalizacija");

            migrationBuilder.DropTable(
                name: "Terapija");

            migrationBuilder.DropTable(
                name: "RasporedSmjena");

            migrationBuilder.DropTable(
                name: "MedicinskoOsoblje");

            migrationBuilder.DropTable(
                name: "Krevet");

            migrationBuilder.DropTable(
                name: "Pregled");

            migrationBuilder.DropTable(
                name: "Smjena");

            migrationBuilder.DropTable(
                name: "Soba");

            migrationBuilder.DropTable(
                name: "Uputnica");

            migrationBuilder.DropTable(
                name: "MedicinskaDokumentacija");

            migrationBuilder.DropTable(
                name: "Termin");

            migrationBuilder.DropTable(
                name: "Pacijent");

            migrationBuilder.DropTable(
                name: "Korisnik");

            migrationBuilder.DropTable(
                name: "Odjel");

            migrationBuilder.DropTable(
                name: "Bolnica");

            migrationBuilder.DropTable(
                name: "Doktor");
        }
    }
}
