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
    public interface IKrevetService : ICRUDService<Krevet, KrevetSearchObject, KrevetInsertRequest, KrevetUpdateRequest>
    {
        public List<Model.Models.Krevet> GetKrevetBySobaId(int sobaId);
        public List<Model.Models.Krevet> GetSlobodanKrevetBySobaId(int sobaId);
        public Model.Response.PopunjenostBolniceResponse GetPopunjenostBolnice();
    }
}
