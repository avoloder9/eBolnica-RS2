using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eBolnica.Model.Messages;
namespace eBolnica.Services.RabbitMQ
{
    public interface IRabbitMQService
    {
        Task SendEmail(Email email);
    }
}
