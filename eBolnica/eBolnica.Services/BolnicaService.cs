﻿using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services
{
    public class BolnicaService : BaseCRUDService<Model.Bolnica, BolnicaSearchObject, Database.Bolnica, BolnicaInsertRequest, BolnicaUpdateRequest>, IBolnicaService
    {
        public BolnicaService(EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Bolnica> AddFilter(BolnicaSearchObject searchObject, IQueryable<Bolnica> query)
        {
            query = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject?.NazivGTE))
            {
                query = query.Where(x => x.Naziv.StartsWith(searchObject.NazivGTE));
            }
            return query;
        }
    }
}