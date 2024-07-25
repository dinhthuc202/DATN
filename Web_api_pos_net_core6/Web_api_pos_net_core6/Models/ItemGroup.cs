using Dapper;
using Microsoft.VisualBasic;
using System.Data.SqlClient;

namespace Web_api_pos_net_core6.Models
{
    public class ItemGroup
    {
        public int? Id { get; set; }
        public string GroupName { get; set; }
        public string? Description { get; set; }
        public static async Task<ItemGroup> GetGroup(int id)
        {
            using (var connection = new SqlConnection(Connect.DefaultConnection))
            {
                await connection.OpenAsync();
                string query = "SELECT * FROM [ItemGroups] WHERE Id = @Id";
                var group = await connection.QueryFirstOrDefaultAsync<ItemGroup>(query, new { Id = id });
                return group;
            }
        }
        public static async Task<List<ItemGroup>> GetGroups()
        {
            using (var connection = new SqlConnection(Connect.DefaultConnection))
            {
                await connection.OpenAsync();
                string query = "SELECT * FROM [ItemGroups]";
                var groups = await connection.QueryAsync<ItemGroup>(query);
                return groups.ToList();
            }
        }
    }

}
