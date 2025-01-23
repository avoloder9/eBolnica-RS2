using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eBolnica.Services.Migrations
{
    /// <inheritdoc />
    public partial class UpdateSoba : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Naziv",
                table: "Soba",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Naziv",
                table: "Soba");
        }
    }
}
