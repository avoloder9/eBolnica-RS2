using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services
{
    public interface IBolnicaService : ICRUDService<Model.Bolnica, BolnicaSearchObject, BolnicaInsertRequest, BolnicaUpdateRequest>
    {

    }
}
