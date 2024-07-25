using Dapper;
using System.Data.SqlClient;

namespace Web_api_pos_net_core6.Models
{
    public class WhsHistory
    {
        public int? Id { get; set; }
        public int? ItemId { get; set; }
        public string? ChangeType { get; set; }
        public int? QuantityChange { get; set; }
        public int? PreQuantity { get; set; }
        public int? NewQuantity { get; set; }
        public DateTime? ChangeDate { get; set; }
        public int? UserId { get; set; }
        public string? Description { get; set; }

        public static async Task<bool> AddWhsHistory(WhsHistory whsHistory, SqlTransaction transaction)
        {
            try
            {

                whsHistory.ChangeDate = DateTime.Now;
                whsHistory.PreQuantity = await GetItemQuantity(whsHistory.ItemId.Value, transaction);
                whsHistory.NewQuantity = whsHistory.PreQuantity + whsHistory.QuantityChange;

                string sql = @"
                    INSERT INTO WhsHistory (ItemId, ChangeType, QuantityChange, PreQuantity, NewQuantity, ChangeDate, UserId, Description)
                    VALUES (@ItemId, @ChangeType, @QuantityChange, @PreQuantity, @NewQuantity, @ChangeDate, @UserId, @Description);
                    SELECT CAST(SCOPE_IDENTITY() as int);";

                await transaction.Connection.QuerySingleAsync<int>(sql, new
                {
                    whsHistory.ItemId,
                    whsHistory.ChangeType,
                    whsHistory.QuantityChange,
                    whsHistory.PreQuantity,
                    whsHistory.NewQuantity,
                    whsHistory.ChangeDate,
                    whsHistory.UserId,
                    whsHistory.Description,
                }, transaction);

                await UpdateItemQuantity(whsHistory.ItemId.Value, whsHistory.QuantityChange.Value, transaction);

                return true;

            }
            catch (Exception ex)
            {
                transaction.Rollback();
                Console.WriteLine($"Error: {ex.Message}");
                throw;
            }
        }
        private static async Task<int> GetItemQuantity(int itemId, SqlTransaction transaction)
        {
            string query = "SELECT Stock FROM Items WHERE Id = @ItemId";
            return await transaction.Connection.QuerySingleAsync<int>(query, new { ItemId = itemId }, transaction);
        }
        private static async Task UpdateItemQuantity(int itemId, int quantityChange, SqlTransaction transaction)
        {
            string query = @"
        UPDATE Items
        SET Stock = Stock + @QuantityChange
        WHERE Id = @ItemId";

            await transaction.Connection.ExecuteAsync(query, new { QuantityChange = quantityChange, ItemId = itemId }, transaction);
        }

    }

}
