using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.Services
{
    public class TerapijaService : BaseCRUDService<Terapija, TerapijaSearchObject, Database.Terapija, TerapijaInsertRequest, TerapijaUpdateRequest>, ITerapijaService
    {
        public TerapijaService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override void BeforeInsert(TerapijaInsertRequest request, Database.Terapija entity)
        {
            var pregledExists = Context.Pregleds.Any(p => p.PregledId == request.PregledId);
            if (!pregledExists)
            {
                throw new Exception("Pregled sa zadanim ID-om ne postoji");
            }
            base.BeforeInsert(request, entity);
        }
    }
}
