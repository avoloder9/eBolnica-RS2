using MimeKit;
using MailKit.Net.Smtp;
using DotNetEnv;
namespace eBolnica.Subscriber.MailSenderService
{
    public class MailSenderService : IMailSenderService
    {
        public async Task SendEmail(Email emailObj)
        {
            if (emailObj == null) return;

           DotNetEnv.Env.Load();

            string fromAddress = Environment.GetEnvironmentVariable("_fromAddress") ?? "ebolnicars2@gmail.com";
            string password = Environment.GetEnvironmentVariable("_password") ?? string.Empty;
            string host = Environment.GetEnvironmentVariable("_host") ?? "smtp.gmail.com";
            int port = int.Parse(Environment.GetEnvironmentVariable("_port") ?? "465");
            bool enableSSL = bool.Parse(Environment.GetEnvironmentVariable("_enableSSL") ?? "true");
            string displayName = Environment.GetEnvironmentVariable("_displayName") ?? "no-reply";
            int timeout = int.Parse(Environment.GetEnvironmentVariable("_timeout") ?? "255");
            Console.WriteLine($"fromAddress: {Environment.GetEnvironmentVariable("_fromAddress")}");
            Console.WriteLine($"password: {Environment.GetEnvironmentVariable("_password")}");

            if (password == string.Empty)
            {
                Console.WriteLine("Password je prazan.");
                return;
            }

            var email = new MimeMessage();

            email.From.Add(new MailboxAddress(displayName, fromAddress));
            email.To.Add(new MailboxAddress(emailObj.ReceiverName, emailObj.EmailTo));

            email.Subject = emailObj.Subject;
            email.Body = new TextPart(MimeKit.Text.TextFormat.Html)
            {
                Text = emailObj.Message
            };

            try
            {
                Console.WriteLine("Spajanje na SMTP server...");

                using (var smtp = new SmtpClient())
                {
                    await smtp.ConnectAsync(host, port, enableSSL);
                    Console.WriteLine("Uspješno spojeno na SMTP server...");

                    await smtp.AuthenticateAsync(fromAddress, password);
                    Console.WriteLine("Autentifikacija na SMTP serveru uspješna.");

                    await smtp.SendAsync(email);

                    await smtp.DisconnectAsync(true);
                }
                Console.WriteLine("Mail uspjesno poslan.");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error {ex.Message}");
                return;
            }
        }
    }
}
