﻿using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using eBolnica.Services.Helpers;
using eBolnica.Services.Interfaces;
using eBolnica.Model.Models;

namespace eBolnica.Services.Services
{
    public class AdministratorService : BaseCRUDService<Model.Models.Administrator, AdministratorSearchObject, Database.Administrator, AdministratorInsertRequest, AdministratorUpdateRequest>, IAdministratorService
    {
        public AdministratorService(EBolnicaContext context, IMapper mapper) : base(context, mapper)
        { }
        public override void BeforeInsert(AdministratorInsertRequest request, Database.Administrator entity)
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
                LozinkaSalt = salt
            };

            Context.Korisniks.Add(korisnik);
            Context.SaveChanges();
            entity.Korisnik = korisnik;
            entity.KorisnikId = korisnik.KorisnikId;

            base.BeforeInsert(request, entity);
        }
        public override IQueryable<Database.Administrator> AddFilter(AdministratorSearchObject searchObject, IQueryable<Database.Administrator> query)
        {
            query = base.AddFilter(searchObject, query);
            query = query.Include(x => x.Korisnik);

            if (!string.IsNullOrWhiteSpace(searchObject?.ImeGTE))
            {
                query = query.Where(x => x.Korisnik.Ime.StartsWith(searchObject.ImeGTE));
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.PrezimeGTE))
            {
                query = query.Where(x => x.Korisnik.Prezime.StartsWith(searchObject.PrezimeGTE));
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.Email))
            {
                query = query.Where(x => x.Korisnik.Email == searchObject.Email);
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.KorisnickoIme))
            {
                query = query.Where(x => x.Korisnik.KorisnickoIme == searchObject.KorisnickoIme);
            }

            return query;
        }

        public override void BeforeUpdate(AdministratorUpdateRequest request, Database.Administrator entity)
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

        public override Model.Models.Administrator GetById(int id)
        {
            var entity = Context.Set<Database.Administrator>().Include(x => x.Korisnik).FirstOrDefault(a => a.AdministratorId == id);
            if (entity == null)
            {
                return null;
            }
            return Mapper.Map<Model.Models.Administrator>(entity);
        }
        public int GetAdministratorIdByKorisnikId(int korisnikId)
        {
            var admin = Context.Administrators.FirstOrDefault(t => t.KorisnikId == korisnikId);
            return admin.AdministratorId;
        }
    }
}
