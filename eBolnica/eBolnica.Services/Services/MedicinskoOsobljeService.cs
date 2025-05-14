using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Helpers;
using eBolnica.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.Services
{
    public class MedicinskoOsobljeService : BaseCRUDService<MedicinskoOsoblje, MedicinskoOsobljeSearchObject, Database.MedicinskoOsoblje, MedicinskoOsobljeInsertRequest, MedicinskoOsobljeUpdateRequest>, IMedicinskoOsobljeService
    {
        public MedicinskoOsobljeService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        { }
        public override IQueryable<Database.MedicinskoOsoblje> AddFilter(MedicinskoOsobljeSearchObject searchObject, IQueryable<Database.MedicinskoOsoblje> query)
        {
            query = base.AddFilter(searchObject, query).Include(x => x.Korisnik).Include(y => y.Odjel).OrderBy(x => x.Korisnik.Ime).Where(x => x.Obrisano == false);

            if (!string.IsNullOrWhiteSpace(searchObject?.ImeGTE))
            {
                query = query.Where(x => x.Korisnik.Ime.StartsWith(searchObject.ImeGTE));
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.PrezimeGTE))
            {
                query = query.Where(x => x.Korisnik.Prezime.StartsWith(searchObject.PrezimeGTE));
            }
            if (!string.IsNullOrWhiteSpace(searchObject?.NazivOdjela))
            {
                query = query.Where(x => x.Odjel.Naziv.StartsWith(searchObject.NazivOdjela));
            }

            if (searchObject?.DatumSmjene != null && searchObject?.VrijemeSmjene != null)
            {

                var vrijeme = searchObject!.VrijemeSmjene!.Value;
                var datum = searchObject!.DatumSmjene!.Value;
                query = query.Where(x => x.Korisnik.RasporedSmjenas.Any(rs => rs.Datum.Date == datum && rs.Smjena.VrijemePocetka <= vrijeme && rs.Smjena.VrijemeZavrsetka >= vrijeme));
            }

            return query;
        }
        public override void BeforeInsert(MedicinskoOsobljeInsertRequest request, Database.MedicinskoOsoblje entity)
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

            var odjelExists = Context.Odjels.Any(o => o.OdjelId == request.OdjelId);
            if (!odjelExists)
            {
                throw new Exception("Odjel s navedenim ID-em ne postoji.");
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
            entity.OdjelId = request.OdjelId;

            base.BeforeInsert(request, entity);
        }

        public override MedicinskoOsoblje Update(int id, MedicinskoOsobljeUpdateRequest request)
        {
            var entity=Context.MedicinskoOsobljes.Include(x=>x.Korisnik).Include(x=>x.Odjel).FirstOrDefault(x=>x.MedicinskoOsobljeId==id);
            if (entity == null) throw new Exception("Medicinsko osoblje nije pronadjeno");
            Mapper.Map(request, entity);
            BeforeUpdate(request, entity);
            Context.SaveChanges();
            return Mapper.Map<MedicinskoOsoblje>(entity);
        }
        public override void BeforeUpdate(MedicinskoOsobljeUpdateRequest request, Database.MedicinskoOsoblje entity)
        {

            if (!string.IsNullOrEmpty(request.Lozinka))
            {
                var pw = ValidationHelper.CheckPasswordStrength(request.Lozinka);
                if (!string.IsNullOrEmpty(pw))
                {
                    throw new Exception("Lozinka nije validna");
                }

                if (request.Lozinka != request.LozinkaPotvrda)
                {
                    throw new Exception("Lozinka i LozinkaPotvrda moraju biti iste");
                }

                entity.Korisnik.LozinkaSalt = HashGenerator.GenerateSalt();
                entity.Korisnik.LozinkaHash = HashGenerator.GenerateHash(entity.Korisnik.LozinkaSalt, request.Lozinka);
            }

            if (!string.IsNullOrEmpty(request.Telefon))
            {
                var phoneNumber = ValidationHelper.CheckPhoneNumber(request.Telefon);
                if (!string.IsNullOrEmpty(phoneNumber))
                {
                    throw new Exception("Broj telefona nije validan");
                }
            }

            if (request.OdjelId != null && request.OdjelId != 0)
            {
                var odjelExists = Context.Odjels.Any(o => o.OdjelId == request.OdjelId);
                if (!odjelExists)
                {
                    throw new Exception("Odjel s navedenim ID-em ne postoji.");
                }

                entity.OdjelId = request.OdjelId.Value;
            }
            var korisnik = Context.Korisniks.Find(entity.KorisnikId);
            var odjel = Context.Odjels.Find(entity.OdjelId);

            if (korisnik != null)
            {
                Mapper.Map(request, korisnik);
            }
            if (odjel != null)
            {
                Mapper.Map(request, odjel);
            }
        }

        public override MedicinskoOsoblje GetById(int id)
        {

            var entity = Context.Set<Database.MedicinskoOsoblje>().Include(x => x.Korisnik).Include(y => y.Odjel).FirstOrDefault(a => a.MedicinskoOsobljeId == id);
            if (entity == null)
            {
                return null!;
            }
            return Mapper.Map<MedicinskoOsoblje>(entity);
        }
        public int GetOsobljeIdByKorisnikId(int korisnikId)
        {
            var osoblje = Context.MedicinskoOsobljes.FirstOrDefault(t => t.KorisnikId == korisnikId);
            return osoblje!.MedicinskoOsobljeId;
        }
        public int? GetOdjelIdByOsobljeId(int osobljeId)
        {
            return Context.MedicinskoOsobljes.Where(o => o.MedicinskoOsobljeId == osobljeId).Select(x => x.OdjelId).FirstOrDefault();
        }

        public override void Delete(int id)
        {
            var entity = Context.Set<Database.MedicinskoOsoblje>().Find(id);
            if (entity == null) { throw new Exception("Medicinsko osoblje nije pronadjeno"); }
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
