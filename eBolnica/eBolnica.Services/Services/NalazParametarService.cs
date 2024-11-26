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
    public class NalazParametarService : BaseCRUDService<NalazParametar, NalazParametarSearchObject, Database.NalazParametar, NalazParametarInsertRequest, NalazParametarUpdateRequest>, INalazParametarService
    {
        public NalazParametarService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
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
    }
}
