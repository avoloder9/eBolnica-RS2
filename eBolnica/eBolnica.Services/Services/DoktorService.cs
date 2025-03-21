using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Helpers;
using eBolnica.Services.Interfaces;
using Mapster;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.Services
{
    public class DoktorService : BaseCRUDService<Doktor, DoktorSearchObject, Database.Doktor, DoktorInsertRequest, DoktorUpdateRequest>, IDoktorService
    {
        public DoktorService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override void BeforeInsert(DoktorInsertRequest request, Database.Doktor entity)
        {
            if (request.Lozinka != request.LozinkaPotvrda)
            {
                throw new Exception("Lozinka i LozinkaPotvrda moraju biti iste");
            }
            var odjelExists = Context.Set<Database.Odjel>().Any(d => d.OdjelId == request.OdjelId);
            if (!odjelExists)
            {
                throw new Exception("Odjel s tim Id-om ne postoji");
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
            entity.Biografija = request.Biografija;
            entity.Specijalizacija = request.Specijalizacija;
            entity.OdjelId = request.OdjelId;
            base.BeforeInsert(request, entity);
        }
        public override IQueryable<Database.Doktor> AddFilter(DoktorSearchObject searchObject, IQueryable<Database.Doktor> query)
        {
            query = base.AddFilter(searchObject, query).Include(x => x.Korisnik).Include(y => y.Odjel);

            if (!string.IsNullOrWhiteSpace(searchObject?.ImeGTE))
            {
                query = query.Where(x => x.Korisnik.Ime.StartsWith(searchObject.ImeGTE));
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.PrezimeGTE))
            {
                query = query.Where(x => x.Korisnik.Prezime.StartsWith(searchObject.PrezimeGTE));
            }

            return query;
        }

        public override Doktor GetById(int id)
        {
            var entity = Context.Set<Database.Doktor>().Include(x => x.Korisnik).Include(x => x.Odjel).FirstOrDefault(a => a.DoktorId == id);
            if (entity == null)
            {
                return null;
            }
            return Mapper.Map<Doktor>(entity);
        }
        public override void BeforeUpdate(DoktorUpdateRequest request, Database.Doktor entity)
        {
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
        public int GetDoktorIdByKorisnikId(int korisnikId)
        {
            var admin = Context.Doktors.FirstOrDefault(t => t.KorisnikId == korisnikId);
            return admin.DoktorId;
        }

        public List<Model.Models.Pregled> GetPreglediByDoktorId(int doktorId)
        {
            var pregledi = Context.Set<Database.Pregled>().Where(x => x.Uputnica.Termin.DoktorId == doktorId)
                .Include(u => u.Uputnica).ThenInclude(t => t.Termin).ThenInclude(x => x.Pacijent).ThenInclude(k => k.Korisnik)
                .OrderBy(x => x.Uputnica.DatumKreiranja).ToList();
            if (pregledi.Count == 0)
            {
                throw new Exception("Nema obavljenih pregleda kod ovog doktora");
            }
            var pregledModel = pregledi.Select(p => new Model.Models.Pregled
            {
                PregledId = p.PregledId,
                Anamneza = p.Anamneza,
                GlavnaDijagnoza = p.GlavnaDijagnoza,
                Zakljucak = p.Zakljucak,
                Uputnica = new Model.Models.Uputnica
                {
                    Termin = new Model.Models.Termin
                    {
                        DatumTermina = p.Uputnica.Termin.DatumTermina,
                        Pacijent = new Model.Models.Pacijent
                        {
                            PacijentId = p.Uputnica.Termin.PacijentId,
                            Korisnik = new Model.Models.Korisnik
                            {
                                KorisnikId = p.Uputnica.Termin.Pacijent.KorisnikId,
                                Ime = p.Uputnica.Termin.Pacijent.Korisnik.Ime,
                                Prezime = p.Uputnica.Termin.Pacijent.Korisnik.Prezime
                            }
                        }
                    }
                }
            }).ToList();
            return pregledModel;
        }
        public List<Model.Models.Termin> GetTerminByDoktorId(int doktorId)
        {
            var termini = Context.Set<Database.Termin>().Where(x => x.DoktorId == doktorId)
               .Include(x => x.Pacijent).ThenInclude(y => y.Korisnik).Include(d => d.Doktor)
               .ThenInclude(k => k.Korisnik).Include(o => o.Odjel)
               .Where(x => x.DatumTermina.Date >= DateTime.Today && x.Otkazano == false)
               .Where(x => x.Uputnicas.Any(u => u.StateMachine != "closed"))
               .OrderBy(x => x.DatumTermina).ToList();

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

        public List<Model.Models.Operacija> GetOperacijaByDoktorId(int doktorId)
        {
            var operacije = Context.Set<Database.Operacija>().Where(x => x.DoktorId == doktorId)
                .Include(x => x.Doktor).ThenInclude(x => x.Korisnik).Include(x => x.Doktor).ThenInclude(x => x.Odjel)
                .Include(x => x.Terapija).Include(x => x.Pacijent).ThenInclude(x => x.Korisnik)
                .Where(x => x.StateMachine != "closed").OrderBy(x => x.DatumOperacije).ToList();
            if (!operacije.Any())
            {
                return new List<Model.Models.Operacija>();
            }
            var operacijeModel = operacije.Select(o => new Model.Models.Operacija
            {
                OperacijaId = o.OperacijaId,
                DatumOperacije = o.DatumOperacije,
                StateMachine = o.StateMachine,
                Komentar = o.Komentar,
                TipOperacije = o.TipOperacije,
                DoktorId = o.DoktorId,
                PacijentId = o.PacijentId,
                TerapijaId = o.TerapijaId,
                Doktor = new Model.Models.Doktor
                {
                    Odjel = new Model.Models.Odjel
                    {
                        Naziv = o.Doktor.Odjel.Naziv
                    },
                    Korisnik = new Model.Models.Korisnik
                    {
                        Ime = o.Doktor.Korisnik.Ime,
                        Prezime = o.Doktor.Korisnik.Prezime
                    }
                },
                Pacijent = new Model.Models.Pacijent
                {
                    Korisnik = new Model.Models.Korisnik
                    {
                        Ime = o.Pacijent.Korisnik.Ime,
                        Prezime = o.Pacijent.Korisnik.Prezime
                    }
                },
                Terapija = o.Terapija != null ? new Model.Models.Terapija
                {
                    Naziv = o.Terapija.Naziv,
                    Opis = o.Terapija.Opis
                } : null

            }).ToList();
            return operacijeModel;
        }
        public async Task<Model.Response.DnevniRasporedResponse> GetDnevniRasporedAsync(int doktorId)
        {
            var danas = DateTime.Today;
            var termini = (await Context.Termins.Where(t => t.DoktorId == doktorId && t.DatumTermina.Date == danas)
                .Include(x => x.Doktor).ThenInclude(x => x.Korisnik).Include(x => x.Pacijent).ThenInclude(x => x.Korisnik).ToListAsync()).Adapt<List<Model.Models.Termin>>();
            var operacije = (await Context.Operacijas.Where(o => o.DoktorId == doktorId && o.DatumOperacije.Date == danas)
                .Include(x => x.Doktor).ThenInclude(x => x.Korisnik).Include(x => x.Pacijent).ThenInclude(x => x.Korisnik).ToListAsync()).Adapt<List<Model.Models.Operacija>>();
            return new Model.Response.DnevniRasporedResponse
            {
                DoktorId = doktorId,
                Datum = danas,
                Termini = termini,
                Operacije = operacije
            };
        }
    }
}
