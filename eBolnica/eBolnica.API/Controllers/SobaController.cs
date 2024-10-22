﻿using eBolnica.Model;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services;
using Microsoft.AspNetCore.Mvc;

namespace eBolnica.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class SobaController : BaseCRUDController<Soba, SobaSearchObject, SobaInsertRequest, SobaUpdateRequest>
    {
        public SobaController(ISobaService service) : base(service) { }
    }
}