﻿using eBolnica.Model.Models;
using eBolnica.Model.Requests;
using eBolnica.Model.SearchObjects;
using eBolnica.Services.Interfaces;
using eBolnica.Services.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Identity.Client;

namespace eBolnica.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class OdjelController : BaseCRUDController<Odjel, OdjelSearchObject, OdjelInsertRequest, OdjelUpdateRequest>
    {
        public readonly IOdjelService odjelService;
        public OdjelController(IOdjelService service) : base(service)
        {
            odjelService = service;
        }
        [HttpGet("GetDoktorByOdjel")]
        public IActionResult GetDoktorByOdjel(int odjelId)
        {
            try
            {
                var doktori = odjelService.GetDoktorByOdjelId(odjelId);
                return Ok(doktori);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet("GetTerminByOdjelId")]
        public IActionResult GetTerminByOdjelId(int odjelId)
        {
            try
            {
                var termini = odjelService.GetTerminByOdjelId(odjelId);
                return Ok(termini);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet("get-odjel/{doktorId}")]
        public IActionResult GetOdjelByDoktorId(int doktorId)
        {
            var odjel = odjelService.GetOdjelByDoktorId(doktorId);

            if (odjel == null)
                return NotFound("Odjel nije pronađen za datog doktora.");

            return Ok(odjel);
        }

        [HttpGet("broj-zaposlenih")]
        public IActionResult GetUkupanBrojZaposlenihPoOdjelima()
        {
            var result = odjelService.GetUkupanBrojZaposlenihPoOdjelima();
            return Ok(result);
        }
    }
}
