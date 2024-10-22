﻿using eBolnica.Model;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Helpers;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services
{
    public class MedicinskoOsobljeService : BaseCRUDService<MedicinskoOsoblje, MedicinskoOsobljeSearchObject, Database.MedicinskoOsoblje, MedicinskoOsobljeInsertRequest, MedicinskoOsobljeUpdateRequest>, IMedicinskoOsobljeService
    {
        public MedicinskoOsobljeService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        { }
        public override IQueryable<Database.MedicinskoOsoblje> AddFilter(MedicinskoOsobljeSearchObject searchObject, IQueryable<Database.MedicinskoOsoblje> query)
        {
            query = base.AddFilter(searchObject, query).Include(x => x.Korisnik);

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
        public override void BeforeInsert(MedicinskoOsobljeInsertRequest request, Database.MedicinskoOsoblje entity)
        {
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
        public override void BeforeUpdate(MedicinskoOsobljeUpdateRequest request, Database.MedicinskoOsoblje entity)
        {
            if (request.Lozinka != request.LozinkaPotvrda)
            {
                throw new Exception("Lozinka i LozinkaPotvrda moraju biti iste");
            }
            var odjelExists = Context.Odjels.Any(o => o.OdjelId == request.OdjelId);
            if (!odjelExists)
            {
                throw new Exception("Odjel s navedenim ID-em ne postoji.");
            }
            base.BeforeUpdate(request, entity);
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
                return null;
            }
            return Mapper.Map<Model.MedicinskoOsoblje>(entity);
        }
    }
}