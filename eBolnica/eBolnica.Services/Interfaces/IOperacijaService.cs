using eBolnica.Model.Models;
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
        public List<Model.Models.Operacija> GetOperacijaByPacijentId(int pacijentId);
    }
}
