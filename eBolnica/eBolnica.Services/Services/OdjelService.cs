using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.Response;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Database;
using eBolnica.Services.Interfaces;
using Mapster;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.Services
{
    public class OdjelService : BaseCRUDService<Model.Models.Odjel, OdjelSearchObject, Database.Odjel, OdjelInsertRequest, OdjelUpdateRequest>, IOdjelService
    {
        public OdjelService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Database.Odjel> AddFilter(OdjelSearchObject searchObject, IQueryable<Database.Odjel> query)
        {
            query = base.AddFilter(searchObject, query).Include(x => x.Bolnica).Include(y => y.GlavniDoktor).ThenInclude(k => k != null ? k.Korisnik : null);


            if (!string.IsNullOrWhiteSpace(searchObject?.NazivGTE))
            {
                query = query.Where(x => x.Naziv.StartsWith(searchObject.NazivGTE));
            }
            if (searchObject!.DoktorId != null)
            {
                var doktor = Context.Doktors.FirstOrDefault(d => d.DoktorId == searchObject.DoktorId);
                if (doktor != null)
                {
                    query = query.Where(o => o.OdjelId == doktor.OdjelId);
                }
            }
            return query;
        }
        public override void BeforeInsert(OdjelInsertRequest request, Database.Odjel entity)
        {
            var bolnica = Context.Bolnicas.FirstOrDefault(b => b.BolnicaId == entity.BolnicaId);
            if (bolnica == null)
            {
                throw new Exception("Bolnica sa zadanim ID-om ne postoji");
            }
            if (bolnica.UkupanBrojOdjela == null)
            {
                bolnica.UkupanBrojOdjela = 0;
            }
            bolnica.UkupanBrojOdjela++;
            Context.SaveChanges();
            base.BeforeInsert(request, entity);
        }
        public override void BeforeUpdate(OdjelUpdateRequest request, Database.Odjel entity)
        {

            if (request.GlavniDoktorId != 0)
            {
                var doktorExists = Context.Set<Database.Doktor>().Any(d => d.DoktorId == request.GlavniDoktorId);
                if (!doktorExists)
                {
                    throw new Exception("Glavni doktor s tim Id-om ne postoji");
                }
                entity.GlavniDoktorId = request.GlavniDoktorId;
            }
            else
            {
                entity.GlavniDoktorId = null;
            }
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

    }
}

