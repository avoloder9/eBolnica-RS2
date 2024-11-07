using System;
using System.Collections.Generic;
using System.Text;

namespace eBolnica.Model
{
    public class UserException : Exception
    {
        public UserException(string message) :
                   base(message)
        { }
    }
}
