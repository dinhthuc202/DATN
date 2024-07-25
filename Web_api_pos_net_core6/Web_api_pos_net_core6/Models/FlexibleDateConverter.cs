using System.Globalization;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;


namespace Web_api_pos_net_core6.Models
{
    public class FlexibleDateConverter : IsoDateTimeConverter
    {
        public FlexibleDateConverter()
        {
            base.DateTimeFormat = "yyyy-MM-ddTHH:mm:ss";
        }

        public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
            if (reader.TokenType == JsonToken.Null)
            {
                return null;
            }

            if (reader.TokenType == JsonToken.String)
            {
                string dateStr = reader.Value.ToString();
                if (DateTime.TryParseExact(dateStr, "dd-MM-yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime date))
                {
                    return date;
                }
                else if (DateTime.TryParse(dateStr, out date))
                {
                    return date;
                }
            }

            return base.ReadJson(reader, objectType, existingValue, serializer);
        }
    }

}
