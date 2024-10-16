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
    public interface IAdministratorService : ICRUDService<Administrator, AdministratorSearchObject, AdministratorInsertRequest, AdministratorUpdateRequest>
    {
        public Model.Administrator InsertAdministratorWithUserDetails(AdministratorInsertRequest request);
    }
}
