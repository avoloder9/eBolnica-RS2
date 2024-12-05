using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.Helpers
{
    public class SobaHelper
    {
        private readonly Database.EBolnicaContext _context;

        public SobaHelper(Database.EBolnicaContext context)
        {
            _context = context;
        }
        public void ProvjeriZauzetostSobe(int sobaId)
        {
            var sviKrevetiZauzeti = _context.Krevets.Where(k => k.SobaId == sobaId).All(k => k.Zauzet);

            var soba = _context.Sobas.FirstOrDefault(s => s.SobaId == sobaId);
            if (soba != null)
            {
                soba.Zauzeta = sviKrevetiZauzeti;
                _context.SaveChanges();
            }
        }
        public void AzurirajStatusSobeNakonOtpusta(int sobaId)
        {

            var soba = _context.Sobas.FirstOrDefault(s => s.SobaId == sobaId);
            if (soba != null)
            {
                var imaSlobodnihKreveta = _context.Krevets.Any(k => k.SobaId == sobaId && !k.Zauzet);

                soba.Zauzeta = !imaSlobodnihKreveta;
                _context.SaveChanges();
            }
        }     
    }
}
