using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace eBolnica.Services.Helpers
{
    public class ValidationHelper
    {
        public static string CheckPasswordStrength(string password)
        {
            StringBuilder sb = new StringBuilder();
            if (password.Length < 8)
            {
                sb.Append("Lozinka mora sadržavati minimalno 8 karaktera");
            }

            if (!(Regex.IsMatch(password, "[a-z]") && Regex.IsMatch(password, "[A-Z]")))
            {
                sb.Append("Lozinka mora sadržavati minimalno 1 veliko slovo");
            }

            if (!Regex.IsMatch(password, "[0-9]"))
            {
                sb.Append("Lozinka mora sadržavati minimalno 1 broj");
            }

            if (!(Regex.IsMatch(password, "[<,>,@,!,#,$,%,^,&,*,-,+,/,|,~,=]")))
            {
                sb.Append("Lozinka mora sadržavati minimalno 1 specijalan znak");
            }
            return sb.ToString();
        }

        public static string CheckPhoneNumber(string phoneNumber)
        {
            if (int.TryParse(phoneNumber, out _))
            {
                if (!(phoneNumber.Length == 9 || phoneNumber.Length == 10))
                {
                    return "Broj telefona mora imati 9 ili 10 cifara";
                }
                return string.Empty;
            }
            else
            {
                return "Unesen broj nije validan";
            }
        }
    }
}
