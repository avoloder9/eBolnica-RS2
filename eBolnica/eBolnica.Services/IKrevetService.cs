using eBolnica.Model;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services
{
    public interface IKrevetService : ICRUDService<Krevet, KrevetSearchObject, KrevetInsertRequest, KrevetUpdateRequest>
    {
    }
}
