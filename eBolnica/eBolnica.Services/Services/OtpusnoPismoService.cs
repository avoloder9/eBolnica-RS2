using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Helpers;
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
        private readonly SobaHelper _sobaHelper;
        public OtpusnoPismoService(Database.EBolnicaContext context, IMapper mapper, SobaHelper sobaHelper) : base(context, mapper)
        {
            _sobaHelper = sobaHelper;
        }
        public override void BeforeInsert(OtpusnoPismoInsertRequest request, Database.OtpusnoPismo entity)
        {
            var terapijaExists = Context.Terapijas.Any(t => t.TerapijaId == request.TerapijaId);
            if (!terapijaExists)
            {
                throw new Exception("Terapija sa zadanim ID-om ne postoji");
            }

            var hospitalizacija = Context.Hospitalizacijas.FirstOrDefault(h => h.HospitalizacijaId == request.HospitalizacijaId);
            if (hospitalizacija == null)
            {
                throw new Exception("Hospitalizacija sa zadanim ID-om ne postoji");
            }
            var pacijentId = hospitalizacija.PacijentId;

            var medicinskaDokumentacija = Context.MedicinskaDokumentacijas.FirstOrDefault(md => md.PacijentId == pacijentId);
            if (medicinskaDokumentacija != null)
            {
                medicinskaDokumentacija.Hospitalizovan = false;
                var bolnica = Context.Bolnicas.FirstOrDefault();
                if (bolnica != null)
                {
                    bolnica.TrenutniBrojHospitalizovanih--;
                }
                hospitalizacija.DatumOtpusta = DateTime.Now;
                var krevet = Context.Krevets.FirstOrDefault(k => k.KrevetId == hospitalizacija.KrevetId);
                if (krevet != null)
                {
                    krevet.Zauzet = false;
                }
                Context.SaveChanges();
                _sobaHelper.AzurirajStatusSobeNakonOtpusta(hospitalizacija.SobaId);
            }
            else
            {
                throw new Exception("Medicinska dokumentacija za zadatog pacijenta ne postoji.");
            }

            base.BeforeInsert(request, entity);
        }
    }
}
