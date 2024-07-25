using Dapper;
using Microsoft.VisualBasic;
using System.Data.SqlClient;

namespace Web_api_pos_net_core6.Models
{
    public class Supplier
    {
        public int? Id { get; set; }
        public string Name { get; set; }
        public string Address { get; set; }
        public DateTime? CreateDate { get; set; }
        public DateTime? UpdateDate { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string? Description { get; set; }
        public DateTime? Birthday { get; set; }

        public static async Task<bool> AddSupplier(Supplier newSupplier)
        {
            using (var connection = new SqlConnection(Connect.DefaultConnection))
            {
                await connection.OpenAsync();

                using (var transaction = connection.BeginTransaction())
                {
                    try
                    {
                        string query = @"
                    INSERT INTO [Supplier] (Name, Address, Birthday, CreateDate, Email, Phone, Description)
                    VALUES (@Name, @Address, @Birthday, @CreateDate, @Email, @Phone, @Description);
                    SELECT CAST(SCOPE_IDENTITY() AS INT)";

                        var parameters = new
                        {
                            newSupplier.Name,
                            newSupplier.Address,
                            newSupplier.Birthday,
                            CreateDate = DateTime.Now,
                            newSupplier.Email,
                            newSupplier.Phone,
                            newSupplier.Description,
                        };

                        var supplierId = await connection.ExecuteScalarAsync<int>(query, parameters, transaction);
                        transaction.Commit();
                        return supplierId > 0;
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        Console.WriteLine($"Error occurred: {ex.Message}");
                        throw;
                    }
                }
            }
        }

        public static async Task<bool> UpdateSupplier(Supplier updatedSupplier)
        {
            using (var connection = new SqlConnection(Connect.DefaultConnection))
            {
                await connection.OpenAsync();

                using (var transaction = connection.BeginTransaction())
                {
                    try
                    {
                        string query = @"
                    UPDATE [Supplier]
                    SET Name = @Name,
                        Address = @Address,
                        Birthday = @Birthday,
                        UpdateDate = @UpdateDate,
                        Email = @Email,
                        Phone = @Phone,
                        Description = @Description
                    WHERE Id = @Id";

                        var parameters = new
                        {
                            updatedSupplier.Id,
                            updatedSupplier.Name,
                            updatedSupplier.Address,
                            updatedSupplier.Birthday,
                            UpdateDate = DateTime.Now,
                            updatedSupplier.Email,
                            updatedSupplier.Phone,
                            updatedSupplier.Description,
                        };

                        var rowsAffected = await connection.ExecuteAsync(query, parameters, transaction);
                        transaction.Commit();
                        return rowsAffected > 0;
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        Console.WriteLine($"Error occurred: {ex.Message}");
                        throw;
                    }
                }
            }
        }

        public static async Task<Supplier> GetSupplier(int id)
        {
            using (var connection = new SqlConnection(Connect.DefaultConnection))
            {
                await connection.OpenAsync();
                string query = "SELECT * FROM [Supplier] WHERE Id = @Id";
                var supplier = await connection.QueryFirstOrDefaultAsync<Supplier>(query, new { Id = id });
                return supplier;
            }
        }

        public static async Task<SupplierResponse> GetSuppliers(int? pageNumber, int? pageSize, string? filter)
        {
            using (var connection = new SqlConnection(Connect.DefaultConnection))
            {
                await connection.OpenAsync();

                string where = string.Empty;
                if (!string.IsNullOrEmpty(filter))
                {
                    where = $"WHERE Name LIKE N'%{filter}%' OR Phone LIKE '%{filter}%'";
                }

                string query;
                var parameters = new DynamicParameters();

                if (pageNumber.HasValue && pageSize.HasValue)
                {
                    query = $@"
            SELECT COUNT(*) FROM [Supplier] {where};
            SELECT * FROM [Supplier] {where}
            ORDER BY Id
            OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";

                    parameters.Add("Offset", (pageNumber.Value - 1) * pageSize.Value);
                    parameters.Add("PageSize", pageSize.Value);
                }
                else
                {
                    query = $@"
            SELECT COUNT(*) FROM [Supplier] {where};
            SELECT * FROM [Supplier] {where}
            ORDER BY Id";
                }

                using (var multi = await connection.QueryMultipleAsync(query, parameters))
                {
                    int totalRecords = await multi.ReadFirstAsync<int>();
                    var suppliers = (await multi.ReadAsync<Supplier>()).ToList();

                    return new SupplierResponse
                    {
                        totalPage = pageSize.HasValue ? (int)Math.Ceiling(totalRecords / (double)pageSize.Value) : 1,
                        suppliers = suppliers
                    };
                }
            }
        }

        public static async Task<bool> DeleteSupplier(int id)
        {
            using (var connection = new SqlConnection(Connect.DefaultConnection))
            {
                await connection.OpenAsync();

                using (var transaction = connection.BeginTransaction())
                {
                    try
                    {
                        string query = "DELETE FROM [Supplier] WHERE Id = @Id";

                        var parameters = new { Id = id };

                        var rowsAffected = await connection.ExecuteAsync(query, parameters, transaction);
                        transaction.Commit();
                        return rowsAffected > 0;
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        Console.WriteLine($"Error occurred: {ex.Message}");
                        throw;
                    }
                }
            }
        }
    }

    public class SupplierResponse
    {
        public int totalPage { get; set; }
        public List<Supplier> suppliers { get; set; }
    }
}
