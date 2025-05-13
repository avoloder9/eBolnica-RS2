using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using MapsterMapper;
using Microsoft.Identity.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using eBolnica.Services.Helpers;
using Microsoft.EntityFrameworkCore;
using eBolnica.Services.Interfaces;
using eBolnica.Model.Models;
using System.Security.Cryptography.X509Certificates;
using eBolnica.Model.Response;
using eBolnica.Services.Recommender;

namespace eBolnica.Services.Services
{
    public class PacijentService : BaseCRUDService<Pacijent, PacijentSearchObject, Database.Pacijent, PacijentInsertRequest, PacijentUpdateRequest>, IPacijentService
    {
        private readonly IRecommenderService recommenderService;
        public PacijentService(Database.EBolnicaContext context, IMapper mapper, IRecommenderService recommenderService) : base(context, mapper)
        {
            this.recommenderService = recommenderService;
        }
        public override void BeforeInsert(PacijentInsertRequest request, Database.Pacijent entity)
        {
            var pw = ValidationHelper.CheckPasswordStrength(request.Lozinka);
            if (!string.IsNullOrEmpty(pw))
            {
                throw new Exception("Lozinka nije validna");
            }
            if (!string.IsNullOrEmpty(request.Telefon))
            {
                var phoneNumber = ValidationHelper.CheckPhoneNumber(request.Telefon);
                if (!string.IsNullOrEmpty(phoneNumber))
                {
                    throw new Exception("Broj telefona nije validan");
                }
            }
            if (request.Lozinka != request.LozinkaPotvrda)
            {
                throw new Exception("Lozinka i LozinkaPotvrda moraju biti iste");
            }
            string salt = HashGenerator.GenerateSalt();
            string hash = HashGenerator.GenerateHash(salt, request.Lozinka);
            var korisnik = new Database.Korisnik
            {
                Ime = request.Ime,
                Prezime = request.Prezime,
                KorisnickoIme = request.KorisnickoIme,
                DatumRodjenja = request.DatumRodjenja,
                Email = request.Email,
                Spol = request.Spol,
                Telefon = request.Telefon,
                Status = request.Status,
                Slika = request.Slika,
                SlikaThumb = request.SlikaThumb,
                LozinkaHash = hash,
                LozinkaSalt = salt,
            };

            Context.Korisniks.Add(korisnik);
            Context.SaveChanges();
            entity.Korisnik = korisnik;
            entity.KorisnikId = korisnik.KorisnikId;
            entity.Adresa = request.Adresa;
            entity.BrojZdravstveneKartice = request.BrojZdravstveneKartice;
            entity.Dob = request.Dob;

            base.BeforeInsert(request, entity);
        }
        public override IQueryable<Database.Pacijent> AddFilter(PacijentSearchObject searchObject, IQueryable<Database.Pacijent> query)
        {
            query = base.AddFilter(searchObject, query);
            query = query.Include(x => x.Korisnik).Where(x => x.Obrisano == false);

            if (!string.IsNullOrWhiteSpace(searchObject?.ImeGTE))
            {
                query = query.Where(x => x.Korisnik.Ime.StartsWith(searchObject.ImeGTE));
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.PrezimeGTE))
            {
                query = query.Where(x => x.Korisnik.Prezime.StartsWith(searchObject.PrezimeGTE));
            }

            if (searchObject?.BrojZdravstveneKartice != null || searchObject!.BrojZdravstveneKartice > 0)
            {
                query = query.Where(x => x.BrojZdravstveneKartice == searchObject.BrojZdravstveneKartice);
            }
            return query;
        }
        public override Pacijent GetById(int id)
        {
            var entity = Context.Set<Database.Pacijent>().Include(x => x.Korisnik).FirstOrDefault(a => a.PacijentId == id);
            if (entity == null)
            {
                return null!;
            }
            return Mapper.Map<Pacijent>(entity);
        }
        public override Pacijent Update(int id, PacijentUpdateRequest request)
        {
            var entity = Context.Pacijents.Include(x => x.Korisnik).FirstOrDefault(x => x.PacijentId== id);
            if (entity == null) throw new Exception("Pacijent nije pronadjeno");
            Mapper.Map(request, entity);
            BeforeUpdate(request, entity);
            Context.SaveChanges();
            return Mapper.Map<Pacijent>(entity);
        }
        public override void BeforeUpdate(PacijentUpdateRequest request, Database.Pacijent entity)
        {
            base.BeforeUpdate(request, entity);
            if (!string.IsNullOrEmpty(request.Lozinka))
            {
                var pw = ValidationHelper.CheckPasswordStrength(request.Lozinka);
                if (!string.IsNullOrEmpty(pw))
                {
                    throw new Exception("Lozinka nije validna");
                }
            }
            if (!string.IsNullOrEmpty(request.Telefon))
            {
                var phoneNumber = ValidationHelper.CheckPhoneNumber(request.Telefon);
                if (!string.IsNullOrEmpty(phoneNumber))
                {
                    throw new Exception("Broj telefona nije validan");
                }
            }
            if (request.Lozinka != null)
            {
                if (request.Lozinka != request.LozinkaPotvrda)
                {
                    throw new Exception("Lozinka i LozinkaPotvrda moraju biti iste");
                }
                entity!.Korisnik.LozinkaSalt = HashGenerator.GenerateSalt();
                entity.Korisnik.LozinkaHash = HashGenerator.GenerateHash(entity.Korisnik.LozinkaSalt, request.Lozinka);
            }
            var korisnik = Context.Korisniks.Find(entity.KorisnikId);
            if (korisnik != null)
            {
                Mapper.Map(request, korisnik);
            }
        }
        public int GetPacijentIdByKorisnikId(int korisnikId)
        {
            var pacijent = Context.Pacijents.FirstOrDefault(t => t.KorisnikId == korisnikId);
            return pacijent!.PacijentId;
        }
        public List<Pacijent> GetPacijentSaDokumentacija()
        {
            return Context.Pacijents.Where(p => Context.MedicinskaDokumentacijas.Any(d => d.PacijentId == p.PacijentId)).Select(p => new Pacijent
            {
                PacijentId = p.PacijentId,
                Korisnik = new Korisnik
                {
                    KorisnikId = p.KorisnikId,
                    Ime = p.Korisnik.Ime,
                    Prezime = p.Korisnik.Prezime
                }
            }).ToList();
        }
        public List<Pacijent> GetPacijentiZaHospitalizaciju()
        {
            return Context.Pacijents.Where(p => Context.MedicinskaDokumentacijas.Any(d => d.PacijentId == p.PacijentId && d.Hospitalizovan == false)).Select(p => new Pacijent
            {
                PacijentId = p.PacijentId,
                Korisnik = new Korisnik
                {
                    KorisnikId = p.KorisnikId,
                    Ime = p.Korisnik.Ime,
                    Prezime = p.Korisnik.Prezime
                }
            }).ToList();
        }
        public async Task<List<PreglediResponse>> GetPreglediByPacijentIdAsync(int pacijentId)
        {
            var result = await Context.Pregleds.Include(u => u.Uputnica).ThenInclude(x => x.Termin).ThenInclude(x => x.Odjel)
                  .Include(u => u.Uputnica).ThenInclude(x => x.Termin).ThenInclude(x => x.Doktor).ThenInclude(x => x.Korisnik)
                  .Include(u => u.Uputnica).ThenInclude(x => x.Termin).ThenInclude(x => x.Pacijent).ThenInclude(x => x.Korisnik)
                  .Where(p => p.MedicinskaDokumentacija!.PacijentId == pacijentId)
                  .ToListAsync();

            var response = result.Select(p => new PreglediResponse
            {
                PregledId = p.PregledId,
                PacijentId = p.Uputnica.Termin.PacijentId,
                ImeDoktora = p.Uputnica!.Termin!.Doktor!.Korisnik!.Ime!,
                PrezimeDoktora = p.Uputnica?.Termin?.Doktor?.Korisnik?.Prezime ?? "Nepoznato",
                ImePacijenta = p.Uputnica?.Termin?.Pacijent.Korisnik.Ime ?? "Nepoznato",
                PrezimePacijenta = p.Uputnica?.Termin?.Pacijent.Korisnik.Prezime ?? "Nepoznato",
                NazivOdjela = p.Uputnica?.Termin?.Odjel?.Naziv ?? "Nepoznato",
                DatumTermina = p.Uputnica?.Termin?.DatumTermina ?? DateTime.MinValue,
                VrijemeTermina = p.Uputnica?.Termin?.VrijemeTermina ?? TimeSpan.Zero,
                GlavnaDijagnoza = p.GlavnaDijagnoza ?? "Nema dijagnoze",
                Anamneza = p.Anamneza ?? "Nema anamneze",
                Zakljucak = p.Zakljucak ?? "Nema zaključka"
            }).ToList();
            return response;
        }
        public async Task<List<Database.Terapija>> GetAktivneTerapijeByPacijentIdAsync(int pacijentId)
        {
            return await Context.Terapijas.Include(x => x.Pregled).ThenInclude(x => x!.MedicinskaDokumentacija).ThenInclude(x => x!.Pacijent).ThenInclude(x => x.Korisnik)
                .Include(x => x.Pregled).ThenInclude(x => x!.Uputnica).ThenInclude(x => x.Termin).ThenInclude(x => x.Doktor).ThenInclude(x => x.Korisnik)
                .Where(x => x.Pregled!.MedicinskaDokumentacija!.PacijentId == pacijentId && x.DatumZavrsetka >= DateTime.Now).ToListAsync();
        }
        public async Task<List<Database.Terapija>> GetGotoveTerapijeByPacijentIdAsync(int pacijentId)
        {
            return await Context.Terapijas.Include(x => x.Pregled).ThenInclude(x => x!.MedicinskaDokumentacija).ThenInclude(x => x!.Pacijent).ThenInclude(x => x.Korisnik)
                .Include(x => x.Pregled).ThenInclude(x => x!.Uputnica).ThenInclude(x => x.Termin).ThenInclude(x => x.Doktor).ThenInclude(x => x.Korisnik)
                .Where(x => x.Pregled!.MedicinskaDokumentacija!.PacijentId == pacijentId && x.DatumZavrsetka < DateTime.Now).ToListAsync();
        }
        public List<Model.Response.BrojZaposlenihPoOdjeluResponse> GetUkupanBrojZaposlenihPoOdjelima()
        {
            return Context.Odjels
                .Select(o => new BrojZaposlenihPoOdjeluResponse
                {
                    OdjelId = o.OdjelId,
                    NazivOdjela = o.Naziv,
                    UkupanBrojZaposlenih = Context.Doktors.Count(d => d.OdjelId == o.OdjelId) +
                                          Context.MedicinskoOsobljes.Count(m => m.OdjelId == o.OdjelId)
                })
                .OrderBy(o => o.NazivOdjela)
                .ToList();
        }
        public BrojPacijenataResponse GetBrojPacijenata()
        {
            var ukupnoPacijenata = Context.Pacijents.Count(p => !p.Obrisano);
            var brojHospitalizovanih = Context.Pacijents
          .Where(p => !p.Obrisano)
          .Count(p => Context.MedicinskaDokumentacijas
              .Any(m => m.PacijentId == p.PacijentId && m.Hospitalizovan.HasValue && m.Hospitalizovan == true));


            return new BrojPacijenataResponse
            {
                UkupanBrojPacijenata = ukupnoPacijenata,
                BrojHospitalizovanih = brojHospitalizovanih
            };
        }
        public List<Model.Models.Doktor> GetPreporuceneDoktore(int pacijentId)
        {
            return recommenderService.GetPreporuceniDoktori(pacijentId);
        }
        public void TrainModel()
        {
            recommenderService.TrainModel();
        }
        public override void Delete(int id)
        {
            var entity = Context.Set<Database.Pacijent>().Find(id);
            if (entity == null) { throw new Exception("Pacijent nije pronadjen"); }
            entity.Obrisano = true;
            entity.VrijemeBrisanja = DateTime.Now;
            Context.Update(entity);
            var korisnik = Context.Set<Database.Korisnik>().Find(entity.KorisnikId);
            if (korisnik == null) { throw new Exception("Korisnik nije pronadjen"); }

            korisnik.Obrisano = true;
            korisnik.VrijemeBrisanja = DateTime.Now;

            Context.Update(korisnik);
            Context.SaveChanges();
        }

    }
}
