using Dapper;
using Microsoft.VisualBasic;
using System.Data.SqlClient;

namespace Web_api_pos_net_core6.Models
{
    public class Item
    {
        public int? Id { get; set; }
        public string Name { get; set; }
        public decimal PurchasePrice { get; set; }
        public decimal SalePrice { get; set; }
        public int? Stock { get; set; }
        public int? UnitId { get; set; }
        public Unit? unitDetails { get; set; }
        public int? GroupId { get; set; }
        public ItemGroup? groupDetails { get; set; }
        public string? BarCode { get; set; }
        public DateTime? CreateDate { get; set; }
        public DateTime? UpdateDate { get; set; }
        public string? Description { get; set; }
        public string? Image { get; set; }


        public static async Task<bool> AddItem(Item newItem)
        {
            try
            {
                using (var connection = new SqlConnection(Connect.DefaultConnection))
                {
                    await connection.OpenAsync();

                    string sql = @"
                    INSERT INTO Items (Name, PurchasePrice, SalePrice, Stock, UnitId, GroupId, BarCode, CreateDate, Description, Image)
                    VALUES (@Name, @PurchasePrice, @SalePrice, @Stock, @UnitId, @GroupId, @BarCode, @CreateDate, @Description, @Image);
                    SELECT CAST(SCOPE_IDENTITY() as int);";

                    newItem.CreateDate = DateTime.Now;
                    newItem.Id = await connection.QuerySingleAsync<int>(sql, new
                    {
                        newItem.Name,
                        newItem.PurchasePrice,
                        newItem.SalePrice,
                        newItem.Stock,
                        newItem.UnitId,
                        newItem.GroupId,
                        newItem.BarCode,
                        CreateDate = DateTime.Now,
                        newItem.Description,
                        newItem.Image
                    });

                    return true;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
                throw;
            }
        }

        public static async Task<bool> UpdateItem(Item updatedItem)
        {
            try
            {
                using (var connection = new SqlConnection(Connect.DefaultConnection))
                {
                    await connection.OpenAsync();

                    string sql = @"
                    UPDATE [Items]
                    SET Name = @Name,
                        PurchasePrice = @PurchasePrice,
                        SalePrice = @SalePrice,
                        Stock = @Stock,
                        UnitId = @UnitId,
                        GroupId = @GroupId,
                        BarCode = @BarCode,
                        UpdateDate = @UpdateDate,
                        Description = @Description,
                        Image = @Image
                    WHERE Id = @Id";

                    updatedItem.UpdateDate = DateTime.Now;
                    int rowsAffected = await connection.ExecuteAsync(sql, new
                    {
                        updatedItem.Id,
                        updatedItem.Name,
                        updatedItem.PurchasePrice,
                        updatedItem.SalePrice,
                        updatedItem.Stock,
                        updatedItem.UnitId,
                        updatedItem.GroupId,
                        updatedItem.BarCode,
                        UpdateDate = DateTime.Now,
                        updatedItem.Description,
                        updatedItem.Image
                    });

                    return rowsAffected > 0;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static async Task<bool> DeleteItem(int id)
        {
            try
            {
                using (var connection = new SqlConnection(Connect.DefaultConnection))
                {
                    await connection.OpenAsync();

                    string sql = "DELETE FROM Items WHERE Id = @Id";
                    int rowsAffected = await connection.ExecuteAsync(sql, new { Id = id });

                    return rowsAffected > 0;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public static async Task<Item> GetItem(int id)
        {
            using (var connection = new SqlConnection(Connect.DefaultConnection))
            {
                await connection.OpenAsync();
                string query = "SELECT * FROM [Items] WHERE Id = @Id";
                var item = await connection.QueryFirstOrDefaultAsync<Item>(query, new { Id = id });



                if (item.Image != null)
                {
                    item.Image = item.Image?.Trim();
                }
                if (item.BarCode != null)
                {
                }
                item.BarCode = item.BarCode?.Trim();

                if (item.UnitId != null)
                {
                    item.unitDetails = await Unit.GetUnit(item.UnitId.Value);
                }

                if (item.GroupId != null)
                {
                    item.groupDetails = await ItemGroup.GetGroup(item.GroupId.Value);
                }
                return item;
            }
        }
        public static async Task<Item> GetItemByBarcode(string barcode)
        {
            using (var connection = new SqlConnection(Connect.DefaultConnection))
            {
                await connection.OpenAsync();
                string query = "SELECT * FROM [Items] WHERE BarCode = @BarCode";
                var item = await connection.QueryFirstOrDefaultAsync<Item>(query, new { BarCode = barcode });

                if (item != null)
                {
                    if (item.Image != null)
                    {
                        item.Image = item.Image?.Trim();
                    }
                    if (item.BarCode != null)
                    {
                        item.BarCode = item.BarCode?.Trim();
                    }

                    if (item.UnitId != null)
                    {
                        item.unitDetails = await Unit.GetUnit(item.UnitId.Value);
                    }

                    if (item.GroupId != null)
                    {
                        item.groupDetails = await ItemGroup.GetGroup(item.GroupId.Value);
                    }
                }

                return item;
            }
        }

        public static async Task<ItemResponse> GetItems(int? pageNumber, int? pageSize, string? filter, bool? inStock = false, int? groupId = null, bool sortByNewest = false)
        {
            using (var connection = new SqlConnection(Connect.DefaultConnection))
            {
                await connection.OpenAsync();

                string where = $"WHERE (Name LIKE N'%{filter}%' OR BarCode LIKE '%{filter}%')";
                string orderBy = sortByNewest ? "Id DESC" : "Id ASC";

                if (inStock == true)
                {
                    where += " AND Stock > 0";
                }

                if (groupId != null)
                {
                    where += $" AND GroupId = {groupId}";
                }

                string query;
                var parameters = new DynamicParameters();

                if (pageNumber.HasValue && pageSize.HasValue)
                {
                    query = $@"
            SELECT COUNT(*) FROM [Items] {where};
            SELECT * FROM [Items] {where}
            ORDER BY {orderBy}
            OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";

                    parameters.Add("Offset", (pageNumber.Value - 1) * pageSize.Value);
                    parameters.Add("PageSize", pageSize.Value);
                }
                else
                {
                    query = $@"
            SELECT COUNT(*) FROM [Items] {where};
            SELECT * FROM [Items] {where}
            ORDER BY {orderBy}";
                }

                using (var multi = await connection.QueryMultipleAsync(query, parameters))
                {
                    int totalRecords = await multi.ReadFirstAsync<int>();
                    var items = (await multi.ReadAsync<Item>()).ToList();

                    foreach (var item in items)
                    {
                        item.Image = item.Image?.Trim();
                        item.BarCode = item.BarCode?.Trim();

                        if (item.UnitId != null)
                        {
                            item.unitDetails = await Unit.GetUnit(item.UnitId.Value);
                        }

                        if (item.GroupId != null)
                        {
                            item.groupDetails = await ItemGroup.GetGroup(item.GroupId.Value);
                        }
                    }

                    return new ItemResponse
                    {
                        totalPage = pageSize.HasValue ? (int)Math.Ceiling(totalRecords / (double)pageSize.Value) : 1,
                        items = items
                    };
                }
            }
        }

    }

    public class ItemResponse
    {
        public int totalPage { get; set; }
        public List<Item> items { get; set; }
    }
}
