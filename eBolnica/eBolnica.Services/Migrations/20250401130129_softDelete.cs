using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eBolnica.Services.Migrations
{
    /// <inheritdoc />
    public partial class softDelete : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "Obrisano",
                table: "VitalniParametri",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "VitalniParametri",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Obrisano",
                table: "Uputnica",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Uputnica",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Obrisano",
                table: "Termin",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Termin",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Obrisano",
                table: "Terapija",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Terapija",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Obrisano",
                table: "Soba",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Soba",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Obrisano",
                table: "Smjena",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Smjena",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Obrisano",
                table: "SlobodniDan",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "SlobodniDan",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Obrisano",
                table: "RasporedSmjena",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "RasporedSmjena",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Obrisano",
                table: "RadniZadatak",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "RadniZadatak",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Obrisano",
                table: "RadniSati",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "RadniSati",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Obrisano",
                table: "Pregled",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Pregled",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Obrisano",
                table: "Parametar",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Parametar",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Obrisano",
                table: "Pacijent",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Pacijent",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Obrisano",
                table: "OtpusnoPismo",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "OtpusnoPismo",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Obrisano",
                table: "Operacija",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Operacija",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Obrisano",
                table: "Odjel",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Odjel",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Obrisano",
                table: "NalazParametar",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "NalazParametar",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Obrisano",
                table: "MedicinskoOsoblje",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "MedicinskoOsoblje",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Obrisano",
                table: "MedicinskaDokumentacija",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "MedicinskaDokumentacija",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Obrisano",
                table: "LaboratorijskiNalaz",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "LaboratorijskiNalaz",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Obrisano",
                table: "Krevet",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Krevet",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Obrisano",
                table: "Korisnik",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Korisnik",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Obrisano",
                table: "Hospitalizacija",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Hospitalizacija",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Obrisano",
                table: "Doktor",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Doktor",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Obrisano",
                table: "Bolnica",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Bolnica",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Obrisano",
                table: "Administrator",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Administrator",
                type: "datetime2",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Obrisano",
                table: "VitalniParametri");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "VitalniParametri");

            migrationBuilder.DropColumn(
                name: "Obrisano",
                table: "Uputnica");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Uputnica");

            migrationBuilder.DropColumn(
                name: "Obrisano",
                table: "Termin");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Termin");

            migrationBuilder.DropColumn(
                name: "Obrisano",
                table: "Terapija");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Terapija");

            migrationBuilder.DropColumn(
                name: "Obrisano",
                table: "Soba");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Soba");

            migrationBuilder.DropColumn(
                name: "Obrisano",
                table: "Smjena");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Smjena");

            migrationBuilder.DropColumn(
                name: "Obrisano",
                table: "SlobodniDan");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "SlobodniDan");

            migrationBuilder.DropColumn(
                name: "Obrisano",
                table: "RasporedSmjena");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "RasporedSmjena");

            migrationBuilder.DropColumn(
                name: "Obrisano",
                table: "RadniZadatak");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "RadniZadatak");

            migrationBuilder.DropColumn(
                name: "Obrisano",
                table: "RadniSati");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "RadniSati");

            migrationBuilder.DropColumn(
                name: "Obrisano",
                table: "Pregled");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Pregled");

            migrationBuilder.DropColumn(
                name: "Obrisano",
                table: "Parametar");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Parametar");

            migrationBuilder.DropColumn(
                name: "Obrisano",
                table: "Pacijent");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Pacijent");

            migrationBuilder.DropColumn(
                name: "Obrisano",
                table: "OtpusnoPismo");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "OtpusnoPismo");

            migrationBuilder.DropColumn(
                name: "Obrisano",
                table: "Operacija");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Operacija");

            migrationBuilder.DropColumn(
                name: "Obrisano",
                table: "Odjel");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Odjel");

            migrationBuilder.DropColumn(
                name: "Obrisano",
                table: "NalazParametar");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "NalazParametar");

            migrationBuilder.DropColumn(
                name: "Obrisano",
                table: "MedicinskoOsoblje");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "MedicinskoOsoblje");

            migrationBuilder.DropColumn(
                name: "Obrisano",
                table: "MedicinskaDokumentacija");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "MedicinskaDokumentacija");

            migrationBuilder.DropColumn(
                name: "Obrisano",
                table: "LaboratorijskiNalaz");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "LaboratorijskiNalaz");

            migrationBuilder.DropColumn(
                name: "Obrisano",
                table: "Krevet");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Krevet");

            migrationBuilder.DropColumn(
                name: "Obrisano",
                table: "Korisnik");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Korisnik");

            migrationBuilder.DropColumn(
                name: "Obrisano",
                table: "Hospitalizacija");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Hospitalizacija");

            migrationBuilder.DropColumn(
                name: "Obrisano",
                table: "Doktor");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Doktor");

            migrationBuilder.DropColumn(
                name: "Obrisano",
                table: "Bolnica");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Bolnica");

            migrationBuilder.DropColumn(
                name: "Obrisano",
                table: "Administrator");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Administrator");
        }
    }
}
