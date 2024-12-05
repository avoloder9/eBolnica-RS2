using eBolnica.Model.Models;
using eBolnica.Model.Requests;
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
    public class MedicinskaDokumentacijaService : BaseCRUDService<MedicinskaDokumentacija, MedicinskaDokumentacijaSearchObject, Database.MedicinskaDokumentacija, MedicinskaDokumentacijaInsertRequest, MedicinskaDokumentacijaUpdateRequest>, IMedicinskaDokumentacijaService
    {
        public MedicinskaDokumentacijaService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Database.MedicinskaDokumentacija> AddFilter(MedicinskaDokumentacijaSearchObject searchObject, IQueryable<Database.MedicinskaDokumentacija> query)
        {
            query = base.AddFilter(searchObject, query).Include(x => x.Pacijent).ThenInclude(y => y.Korisnik);

            if (!string.IsNullOrWhiteSpace(searchObject?.ImeGTE))
            {
                query = query.Where(x => x.Pacijent.Korisnik.Ime.StartsWith(searchObject.ImeGTE));
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.PrezimeGTE))
            {
                query = query.Where(x => x.Pacijent.Korisnik.Prezime.StartsWith(searchObject.PrezimeGTE));
            }

            if (searchObject?.BrojZdravstveneKartice != null && searchObject.BrojZdravstveneKartice > 0)
            {
                query = query.Where(x => x.Pacijent.BrojZdravstveneKartice == searchObject.BrojZdravstveneKartice);
            }
            return query;
        }
        public override MedicinskaDokumentacija GetById(int id)
        {
            var entity = Context.Set<Database.MedicinskaDokumentacija>().Include(x => x.Pacijent).ThenInclude(y => y.Korisnik).FirstOrDefault(a => a.MedicinskaDokumentacijaId == id);
            if (entity == null)
            {
                return null;
            }
            return Mapper.Map<MedicinskaDokumentacija>(entity);
        }
    }
}

