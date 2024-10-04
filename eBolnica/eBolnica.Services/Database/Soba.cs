﻿using System;
using System.Collections.Generic;

namespace eBolnica.Services.Database;

public partial class Soba
{
    public int SobaId { get; set; }

    public int OdjelId { get; set; }

    public int? BrojKreveta { get; set; }

    public bool? Zauzeta { get; set; }

    public virtual ICollection<Hospitalizacija> Hospitalizacijas { get; } = new List<Hospitalizacija>();

    public virtual ICollection<Krevet> Krevets { get; } = new List<Krevet>();

    public virtual Odjel Odjel { get; set; } = null!;
}