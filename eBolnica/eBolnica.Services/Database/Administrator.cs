﻿using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class Administrator
{
    public int AdministratorId { get; set; }

    public int KorisnikId { get; set; }

    public virtual Korisnik Korisnik { get; set; } = null!;
}
