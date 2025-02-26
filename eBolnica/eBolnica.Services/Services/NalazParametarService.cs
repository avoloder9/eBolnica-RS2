using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.Response;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.Services
{
    public class NalazParametarService : BaseCRUDService<NalazParametar, NalazParametarSearchObject, Database.NalazParametar, NalazParametarInsertRequest, NalazParametarUpdateRequest>, INalazParametarService
    {
        public NalazParametarService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Database.NalazParametar> AddFilter(NalazParametarSearchObject searchObject, IQueryable<Database.NalazParametar> query)
        {
            query = query.Include(x => x.LaboratorijskiNalaz)
                   .ThenInclude(y => y.Pacijent)
                   .ThenInclude(z => z.Korisnik)
                   .Include(p => p.Parametar);

            if (!string.IsNullOrWhiteSpace(searchObject.ImePacijenta))
            {
                query = query.Where(x => x.LaboratorijskiNalaz.Pacijent.Korisnik.Ime.Contains(searchObject.ImePacijenta));
            }

            if (!string.IsNullOrWhiteSpace(searchObject.PrezimePacijenta))
            {
                query = query.Where(x => x.LaboratorijskiNalaz.Pacijent.Korisnik.Prezime.Contains(searchObject.PrezimePacijenta));
            }
            if (searchObject?.LaboratorijskiNalazId != null && searchObject.LaboratorijskiNalazId > 0)
            {
                query = query.Where(x => x.LaboratorijskiNalazId == searchObject.LaboratorijskiNalazId);
            }
            return base.AddFilter(searchObject, query);
        }

        public override void BeforeInsert(NalazParametarInsertRequest request, Database.NalazParametar entity)
        {
            var nalazExists = Context.LaboratorijskiNalazs.Any(n => n.LaboratorijskiNalazId == request.LaboratorijskiNalazId);
            if (!nalazExists)
            {
                throw new Exception("Laboratorijski nalaz sa zadanim ID-om ne postoji");
            }
            var parametarExists = Context.Parametars.Any(p => p.ParametarId == request.ParametarId);
            if (!parametarExists)
            {
                throw new Exception("Parametar sa zadanim ID-om ne postoji");
            }
            base.BeforeInsert(request, entity);
        }
        public Task<List<Model.Models.NalazParametar>> GetNalazParametarValues(NalazParametarSearchObject search)
        {
            var query = Context.NalazParametars.AsQueryable();
            query = AddFilter(search, query);

            return query.Select(x => new Model.Models.NalazParametar
            {
                Parametar = new Model.Models.Parametar
                {
                    Naziv = x.Parametar.Naziv,
                    MaxVrijednost = x.Parametar.MaxVrijednost,
                    MinVrijednost = x.Parametar.MinVrijednost,

                },
                Vrijednost = x.Vrijednost,
                LaboratorijskiNalazId = x.LaboratorijskiNalazId
            }).ToListAsync();
        }

    }

}
