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
    public interface IDoktorService : ICRUDService<Doktor, DoktorSearchObject, DoktorInsertRequest, DoktorUpdateRequest>
    {
        public int GetDoktorIdByKorisnikId(int korisnikId);
        public Task<Model.Response.DnevniRasporedResponse> GetDnevniRasporedAsync(int doktorId);

    }
}
