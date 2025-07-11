﻿using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using Mapster;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Identity.Client.Extensibility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.Services
{
    public class SobaService : BaseCRUDService<Soba, SobaSearchObject, Database.Soba, SobaInsertRequest, SobaUpdateRequest>, ISobaService
    {
        public SobaService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Database.Soba> AddFilter(SobaSearchObject searchObject, IQueryable<Database.Soba> query)
        {
            query = base.AddFilter(searchObject, query).Where(x => x.Obrisano == false);

            if (searchObject?.SobaId != null || searchObject!.SobaId > 0)
            {
                query = query.Where(x => x.SobaId == searchObject.SobaId);
            }
            if (searchObject?.OdjelId != null || searchObject!.OdjelId > 0)
            {
                query = query.Include(x => x.Odjel).Where(x => x.OdjelId == searchObject.OdjelId);
            }
            return query;
        }
        public override void BeforeInsert(SobaInsertRequest request, Database.Soba entity)
        {
            var odjel = Context.Set<Database.Odjel>().FirstOrDefault(d => d.OdjelId == request.OdjelId);
            if (odjel == null)
            {
                throw new Exception("Odjel s tim Id-om nije pronađen");
            }
            var bolnica = Context.Bolnicas.FirstOrDefault(b => b.BolnicaId == odjel.BolnicaId);
            if (bolnica == null)
            {
                throw new Exception("Bolnica sa zadanim ID-om ne postoji");
            }
            if (bolnica.UkupanBrojSoba == null)
            {
                bolnica.UkupanBrojSoba = 0;
            }
            bolnica.UkupanBrojSoba++;
            odjel.BrojSoba++;

            Context.SaveChanges();
            entity.Odjel = odjel;

            base.BeforeInsert(request, entity);
        }
        private void ProvjeriStatusSobe(int sobaId)
        {
            var soba = Context.Sobas.FirstOrDefault(s => s.SobaId == sobaId);
            if (soba == null)
            {
                throw new Exception("Soba sa zadanim ID-om ne postoji.");
            }
            var sviKrevetiZauzeti = Context.Krevets
                .Where(k => k.SobaId == sobaId)
                .All(k => k.Zauzet);

            soba.Zauzeta = sviKrevetiZauzeti;
            Context.SaveChanges();
        }
        public List<Model.Models.Soba> GetSlobodneSobaByOdjelId(int odjelId)
        {
            var sobaDatabase = Context.Set<Database.Soba>().Include(s => s.Odjel).Where(x => x.OdjelId == odjelId && x.Zauzeta == false).ToList();
            if (!sobaDatabase.Any())
            {
                return new List<Model.Models.Soba>();

            }
            var sobaModel = sobaDatabase.Select(s => new Model.Models.Soba
            {
                OdjelId = s.OdjelId,
                Naziv = s.Naziv,
                SobaId = s.SobaId,
                BrojKreveta = s.BrojKreveta,
                Zauzeta = s.Zauzeta,
                Odjel = new Model.Models.Odjel
                {
                    Naziv = s.Odjel.Naziv,
                    OdjelId = s.Odjel.OdjelId,
                    BrojKreveta = s.Odjel.BrojKreveta,
                    BrojSlobodnihKreveta = s.Odjel.BrojSlobodnihKreveta,
                    BrojSoba = s.Odjel.BrojSoba
                }
            }).ToList();
            return sobaModel;
        }
        public override void Delete(int id)
        {
            var soba = Context.Sobas.Include(x => x.Odjel).ThenInclude(x => x.Bolnica).FirstOrDefault(s => s.SobaId == id);

            if (soba == null)
            {
                throw new Exception("Sobu nije moguće pronaći.");
            }

            if (soba is ISoftDelete softDeleteEntity)
            {
                softDeleteEntity.Obrisano = true;
                softDeleteEntity.VrijemeBrisanja = DateTime.Now;
                Context.Update(soba);

                if (soba.BrojKreveta.HasValue && soba.BrojKreveta > 0)
                {
                    soba.BrojKreveta--;
                    Context.Update(soba);
                }

                if (soba.Odjel.BrojSoba > 0)
                {
                    soba.Odjel.BrojSoba--;
                    Context.Update(soba.Odjel);
                }

                if (soba.Odjel.Bolnica.UkupanBrojSoba > 0)
                {
                    soba.Odjel.Bolnica.UkupanBrojSoba--;
                    Context.Update(soba.Odjel.Bolnica);
                }
            }
            else
            {
                Context.Remove(soba);
            }

            Context.SaveChanges();
        }

    }
}