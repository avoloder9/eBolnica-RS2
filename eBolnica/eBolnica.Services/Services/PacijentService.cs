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

namespace eBolnica.Services.Services
{
    public class PacijentService : BaseCRUDService<Pacijent, PacijentSearchObject, Database.Pacijent, PacijentInsertRequest, PacijentUpdateRequest>, IPacijentService
    {
        public PacijentService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        { }

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

            if (searchObject?.BrojZdravstveneKartice != null && searchObject.BrojZdravstveneKartice > 0)
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
                return null;
            }
            return Mapper.Map<Pacijent>(entity);
        }
        public override void BeforeUpdate(PacijentUpdateRequest request, Database.Pacijent entity)
        {
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
            if (request.Lozinka != request.LozinkaPotvrda)
            {
                throw new Exception("Lozinka i LozinkaPotvrda moraju biti iste");
            }
            base.BeforeUpdate(request, entity);
            var korisnik = Context.Korisniks.Find(entity.KorisnikId);
            if (korisnik != null)
            {
                Mapper.Map(request, korisnik);
            }
        }

        public List<Model.Models.Termin> GetTerminByPacijentId(int pacijentId)
        {
            var termini = Context.Set<Database.Termin>().Where(x => x.PacijentId == pacijentId)
                .Include(x => x.Pacijent).ThenInclude(y => y.Korisnik).Include(d => d.Doktor)
                .ThenInclude(k => k.Korisnik).Include(o => o.Odjel).Where(x => x.DatumTermina >= DateTime.Now && x.Otkazano == false).OrderBy(x => x.DatumTermina).ToList();

            if (!termini.Any())
            {
                return new List<Model.Models.Termin>();
            }
            var terminModel = termini.Select(p => new Model.Models.Termin
            {
                TerminId = p.TerminId,
                VrijemeTermina = p.VrijemeTermina,
                DatumTermina = p.DatumTermina,
                Otkazano = p.Otkazano,
                Doktor = new Model.Models.Doktor
                {
                    Korisnik = new Model.Models.Korisnik
                    {
                        Ime = p.Doktor.Korisnik.Ime,
                        Prezime = p.Doktor.Korisnik.Prezime,
                        KorisnikId = p.Doktor.KorisnikId
                    }
                },
                DoktorId = p.DoktorId,
                OdjelId = p.OdjelId,
                PacijentId = p.PacijentId,
                Pacijent = new Model.Models.Pacijent
                {
                    PacijentId = p.PacijentId,
                    Korisnik = new Model.Models.Korisnik
                    {
                        Ime = p.Pacijent.Korisnik.Ime,
                        Prezime = p.Pacijent.Korisnik.Prezime,
                        KorisnikId = p.Pacijent.KorisnikId,
                    }
                },
                Odjel = new Model.Models.Odjel
                {
                    OdjelId = p.OdjelId,
                    Naziv = p.Odjel.Naziv,
                }
            }).ToList();
            return terminModel;
        }
        public int GetPacijentIdByKorisnikId(int korisnikId)
        {
            var pacijent = Context.Pacijents.FirstOrDefault(t => t.KorisnikId == korisnikId);
            return pacijent.PacijentId;
        }
        public List<Pacijent> GetPacijentWithDokumentacija()
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
        public async Task<List<Database.Pregled>> GetPreglediByPacijentIdAsync(int pacijentId)
        {
            return await Context.Pregleds.Include(u => u.Uputnica).ThenInclude(x => x.Termin).ThenInclude(x => x.Odjel)
                .Include(u => u.Uputnica).ThenInclude(x => x.Termin).ThenInclude(x => x.Doktor).ThenInclude(x => x.Korisnik)
                .Include(u => u.Uputnica).ThenInclude(x => x.Termin).ThenInclude(x => x.Pacijent).ThenInclude(x => x.Korisnik)
                .Where(p => p.MedicinskaDokumentacija!.PacijentId == pacijentId)
                .ToListAsync();
        }
        public async Task<List<Database.Hospitalizacija>> GetHospitalizacijeByPacijentIdAsync(int pacijentId)
        {
            return await Context.Hospitalizacijas.Include(x => x.MedicinskaDokumentacija).ThenInclude(x => x!.Pacijent).ThenInclude(x => x.Korisnik)
                .Include(x => x.Odjel).Include(x => x.Doktor).ThenInclude(x => x.Korisnik).Where(x => x.MedicinskaDokumentacija!.PacijentId == pacijentId)
                .ToListAsync();
        }
        public async Task<List<Database.OtpusnoPismo>> GetOtpusnaPismaByPacijentIdAsync(int pacijentId)
        {
            return await Context.OtpusnoPismos.Include(x => x.Hospitalizacija).ThenInclude(x => x.MedicinskaDokumentacija)
                .Where(x => x.Hospitalizacija!.MedicinskaDokumentacija!.PacijentId == pacijentId).ToListAsync();
        }
        public async Task<List<Database.Terapija>> GetTerapijaByPacijentIdAsync(int pacijentId)
        {
            return await Context.Terapijas.Include(x => x.Pregled).ThenInclude(x => x!.MedicinskaDokumentacija).ThenInclude(x => x!.Pacijent).ThenInclude(x => x.Korisnik)
                .Include(x => x.Pregled).ThenInclude(x => x.Uputnica).ThenInclude(x => x.Termin).ThenInclude(x => x.Doktor).ThenInclude(x => x.Korisnik)
                .Where(x => x.Pregled!.MedicinskaDokumentacija!.PacijentId == pacijentId).ToListAsync();
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
        public async Task<List<Database.LaboratorijskiNalaz>> GetNalaziByPacijentIdAsync(int pacijentId)
        {
            return await Context.LaboratorijskiNalazs.Include(x => x.Doktor).ThenInclude(x => x.Korisnik).Include(x => x.Pacijent)
                .ThenInclude(x => x.Korisnik).Where(x => x.PacijentId == pacijentId).ToListAsync();
        }
        public async Task<List<Database.Operacija>> GetOperacijeByPacijentIdAsync(int pacijentId)
        {
            return await Context.Operacijas.Include(x => x.Pacijent).ThenInclude(x => x.Korisnik).Include(x => x.Doktor)
                .ThenInclude(x => x.Korisnik).Include(x => x.Terapija).Where(x => x.PacijentId == pacijentId).ToListAsync();
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
    }
}
