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
    public interface ISobaService : ICRUDService<Soba, SobaSearchObject, SobaInsertRequest, SobaUpdateRequest>
    {
        public List<Model.Models.Soba> GetSobaByOdjelId(int odjelId);

    }
}
