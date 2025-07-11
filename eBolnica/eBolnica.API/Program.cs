using eBolnica.API;
using eBolnica.API.Filters;
using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Services.Database;
using eBolnica.Services.Helpers;
using eBolnica.Services.Interfaces;
using eBolnica.Services.OperacijaStateMachine;
using eBolnica.Services.RabbitMQ;
using eBolnica.Services.Recommender;
using eBolnica.Services.Services;
using eBolnica.Services.UputnicaStateMachine;
using Mapster;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Connections.Features;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.OpenApi.Models;
using System.Text.Json.Serialization;

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
builder.Services.AddTransient<IUputnicaService, UputnicaService>();
builder.Services.AddTransient<IPregledService, PregledService>();
builder.Services.AddTransient<IHospitalizacijaService, HospitalizacijaService>();
builder.Services.AddTransient<ITerapijaService, TerapijaService>();
builder.Services.AddTransient<IOperacijaService, OperacijaService>();
builder.Services.AddTransient<ILaboratorijskiNalazService, LaboratorijskiNalazService>();
builder.Services.AddTransient<IParametarService, ParametarService>();
builder.Services.AddTransient<INalazParametarService, NalazParametarService>();
builder.Services.AddTransient<IVitalniParametriService, VitalniParemetriService>();
builder.Services.AddTransient<IRadniZadatakService, RadniZadatakService>();
builder.Services.AddTransient<ISmjenaService, SmjenaService>();
builder.Services.AddTransient<IRasporedSmjenaService, RasporedSmjenaService>();
builder.Services.AddTransient<ISlobodniDanService, SlobodniDanService>();
builder.Services.AddTransient<IRadniSatiService, RadniSatiService>();
builder.Services.AddTransient<IOtpusnoPismoService, OtpusnoPismoService>();

builder.Services.AddTransient<BaseUputnicaState>();
builder.Services.AddTransient<InitialUputnicaState>();
builder.Services.AddTransient<DraftUputnicaState>();
builder.Services.AddTransient<ActiveUputnicaState>();
builder.Services.AddTransient<HiddenUputnicaState>();
builder.Services.AddTransient<ClosedUputnicaState>();

builder.Services.AddTransient<BaseOperacijaState>();
builder.Services.AddTransient<InitialOperacijaState>();
builder.Services.AddTransient<DraftOperacijaState>();
builder.Services.AddTransient<ActiveOperacijaState>();
builder.Services.AddTransient<HiddenOperacijaState>();
builder.Services.AddTransient<ClosedOperacijaState>();
builder.Services.AddTransient<CancelledOperacijaState>();

builder.Services.AddTransient<SobaHelper>();
builder.Services.AddScoped<IRabbitMQService, RabbitMQService>();
builder.Services.AddScoped<IRecommenderService, RecommenderService>();
builder.Services.AddControllers(x =>
{
    x.Filters.Add<ExceptionFilter>();
}).AddJsonOptions(options => options.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles);

builder.Services.AddMapster();
TypeAdapterConfig<eBolnica.Services.Database.Doktor, eBolnica.Model.Models.Doktor>
    .NewConfig()
    .PreserveReference(true)
    .MaxDepth(3);

TypeAdapterConfig<eBolnica.Services.Database.Odjel, eBolnica.Model.Models.Odjel>
    .NewConfig()
    .PreserveReference(true)
    .MaxDepth(3);
TypeAdapterConfig<PacijentInsertRequest, eBolnica.Model.Models.Pacijent>
    .NewConfig()
    .Ignore(dest => dest.PacijentId);
TypeAdapterConfig<eBolnica.Services.Database.Hospitalizacija, eBolnica.Model.Models.Hospitalizacija>
    .NewConfig()
    .PreserveReference(true)
    .MaxDepth(3);

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
app.UseCors(
    options => options
        .SetIsOriginAllowed(x => _ = true)
        .AllowAnyMethod()
        .AllowAnyHeader()
        .AllowCredentials()
);
app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<EBolnicaContext>();
       dataContext.Database.Migrate();   
}
app.Run();
