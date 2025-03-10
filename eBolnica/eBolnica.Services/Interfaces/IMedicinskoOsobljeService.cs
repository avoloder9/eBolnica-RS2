﻿using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.Interfaces
{
    public interface IMedicinskoOsobljeService : ICRUDService<MedicinskoOsoblje, MedicinskoOsobljeSearchObject, MedicinskoOsobljeInsertRequest, MedicinskoOsobljeUpdateRequest>
    {
        public int GetOsobljeIdByKorisnikId(int korisnikId);
        public int? GetOdjelIdByOsobljeId(int osobljeId);

    }
}
