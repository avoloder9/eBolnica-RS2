﻿using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using MapsterMapper;
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
            query = base.AddFilter(searchObject, query);

            if (searchObject?.SobaId != null && searchObject.SobaId > 0)
            {
                query = query.Where(x => x.SobaId == searchObject.SobaId);
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
    }

}