using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model.Response
{
    public class DashboardResponse
    {
        public int BrojPregleda { get; set; }
        public int UkupanBrojPacijenata { get; set; }
        public int BrojHospitalizovanih { get; set; }
        public int BrojOdjela { get; set; }
        public int BrojSoba { get; set; }
        public int BrojKreveta { get; set; }
        public int BrojSlobodnihKreveta { get; set; }
        public int BrojZauzetihKreveta { get; set; }
        public int BrojKorisnika { get; set; }
        public int BrojDoktora { get; set; }
        public int BrojOsoblja { get; set; }
        public List<TerminiPoMjesecima> TerminiPoMjesecima { get; set; } = null!;
    }

    public class TerminiPoMjesecima
    {
        public int Godina { get; set; }
        public int Mjesec { get; set; }
        public int BrojTermina { get; set; }
    }

}
