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
    public interface IOperacijaService : ICRUDService<Operacija, OperacijaSearchObject, OperacijaInsertRequest, OperacijaUpdateRequest>
    {
        public Operacija Activate(int id);
        public Operacija Hide(int id);
        public Operacija Edit(int id);
        public Operacija Close(int id);
        public Operacija Cancelled(int id);
        public List<string> AllowedActions(int id);
        public List<String> ZauzetTermin(int doktorId, DateTime datumOperacije);


    }
}
