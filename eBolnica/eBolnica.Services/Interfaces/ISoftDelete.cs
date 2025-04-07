using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.Interfaces
{
    internal interface ISoftDelete
    {
        public bool Obrisano { get; set; }
        public DateTime? VrijemeBrisanja { get; set; }
        public void Undo()
        {
            Obrisano = false;
            VrijemeBrisanja = null;
        }
    }
}
