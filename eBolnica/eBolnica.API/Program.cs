using eBolnica.API;
using eBolnica.Services.Database;
using eBolnica.Services.Interfaces;
using eBolnica.Services.Services;
using Mapster;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Connections.Features;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddTransient<IKorisnikService, KorisnikService>();
builder.Services.AddTransient<IAdministratorService, AdministratorService>();
builder.Services.AddTransient<IPacijentService, PacijentService>();
builder.Services.AddTransient<IBolnicaService, BolnicaService>();
builder.Services.AddTransient<IDoktorService, DoktorService>();
builder.Services.AddTransient<IOdjelService, OdjelService>();
builder.Services.AddTransient<IMedicinskoOsobljeService, MedicinskoOsobljeService>();
builder.Services.AddTransient<ISobaService, SobaService>();
builder.Services.AddTransient<IKrevetService, KrevetService>();
builder.Services.AddTransient<IMedicinskaDokumentacijaService, MedicinskaDokumentacijaService>();
builder.Services.AddTransient<ITerminService, TerminService>();
builder.Services.AddTransient<IStatusService, StatusService>();
builder.Services.AddTransient<IUputnicaService, UputnicaService>();
builder.Services.AddTransient<IPregledService, PregledService>();
builder.Services.AddTransient<IHospitalizacijaService, HospitalizacijaService>();

builder.Services.AddControllers();
builder.Services.AddMapster();
builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
    {
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference{Type = ReferenceType.SecurityScheme, Id = "basicAuth"}
            },
            new string[]{}
    } });

});
var connectionString = builder.Configuration.GetConnectionString("eBolnicaConnection");
builder.Services.AddDbContext<EBolnicaContext>(options => options.UseSqlServer(connectionString));

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
