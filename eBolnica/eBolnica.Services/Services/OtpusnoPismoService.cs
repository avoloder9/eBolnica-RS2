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
    public class OtpusnoPismoService : BaseCRUDService<OtpusnoPismo, OtpusnoPismoSearchObject, Database.OtpusnoPismo, OtpusnoPismoInsertRequest, OtpusnoPismoUpdateRequest>, IOtpusnoPismoService
    {
        public OtpusnoPismoService(Database.EBolnicaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override void BeforeInsert(OtpusnoPismoInsertRequest request, Database.OtpusnoPismo entity)
        {
            var terapijaExists = Context.Terapijas.Any(t => t.TerapijaId == request.TerapijaId);
            if (!terapijaExists)
            {
                throw new Exception("Terapija sa zadanim ID-om ne postoji");
            }
            base.BeforeInsert(request, entity);
        }
    }
}
