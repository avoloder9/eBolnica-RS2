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
    public interface IUputnicaService : ICRUDService<Uputnica, UputnicaSearchObject, UputnicaInsertRequest, UputnicaUpdateRequest>
    {
        public Uputnica Activate(int id);
        public Uputnica Hide(int id);
        public Uputnica Edit(int id);
        public Uputnica Close(int id);
        public List<string> AllowedActions(int id);
    }
}
