namespace Web_api_pos_net_core6.Models
{
    public class Connect
    {
        public static string DefaultConnection { get; private set; }

        static Connect()
        {
            var builder = new ConfigurationBuilder()
                .SetBasePath(AppContext.BaseDirectory)
                .AddJsonFile("appsettings.json");

            var configuration = builder.Build();
            DefaultConnection = configuration.GetConnectionString("DefaultConnnection");
        }
    }
}
