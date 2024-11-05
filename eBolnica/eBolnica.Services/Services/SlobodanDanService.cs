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
    public class SlobodanDanService : BaseCRUDService<SlobodniDan, SlobodniDanSearchObject, Database.SlobodniDan, SlobodanDanInsertRequest, SlobodanDanUpdateRequest>, ISlobodanDanService
    {
        public SlobodanDanService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Database.SlobodniDan> AddFilter(SlobodniDanSearchObject searchObject, IQueryable<Database.SlobodniDan> query)
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
        public override void BeforeInsert(SlobodanDanInsertRequest request, Database.SlobodniDan entity)
        {
            var isDoktor = Context.Doktors.Any(p => p.KorisnikId == request.KorisnikId);
            var isMedicinskoOsoblje = Context.MedicinskoOsobljes.Any(m => m.KorisnikId == request.KorisnikId);

            if (!isDoktor && !isMedicinskoOsoblje)
            {
                throw new Exception("Korisnik mora biti doktor ili medicinsko osoblje da bi mu se mogao dodjeliti slobodan dan.");
            }
            base.BeforeInsert(request, entity);
        }
    }
}
