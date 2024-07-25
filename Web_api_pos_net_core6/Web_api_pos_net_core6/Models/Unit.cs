using Dapper;
using Microsoft.VisualBasic;
using System.Data.SqlClient;

namespace Web_api_pos_net_core6.Models
{
    public class Unit
    {
        public int? Id { get; set; }
        public string UnitName { get; set; }
        public string? Description { get; set; }

        public static async Task<Unit> GetUnit(int id)
        {
            using (var connection = new SqlConnection(Connect.DefaultConnection))
            {
                await connection.OpenAsync();
                string query = "SELECT * FROM [Unit] WHERE Id = @Id";
                var unit = await connection.QueryFirstOrDefaultAsync<Unit>(query, new { Id = id });
                unit.UnitName = unit.UnitName?.Trim();
                return unit;
            }
        }

        public static async Task<List<Unit>> GetUnits()
        {
            using (var connection = new SqlConnection(Connect.DefaultConnection))
            {
                await connection.OpenAsync();
                string query = "SELECT * FROM [Unit]";
                var units = (await connection.QueryAsync<Unit>(query)).ToList();
                foreach (var unit in units)
                {
                    unit.UnitName = unit.UnitName.Trim();
                    if (unit.Description != null)
                    {
                        unit.Description = unit.Description.Trim();
                    }
                }
                return units.ToList();
            }
        }

    }
}
