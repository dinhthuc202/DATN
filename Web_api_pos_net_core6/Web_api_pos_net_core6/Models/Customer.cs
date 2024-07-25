using Newtonsoft.Json;
using Dapper;
using System.Data.SqlClient;

namespace Web_api_pos_net_core6.Models
{
    public class Customer
    {
        public int? Id { get; set; }
        public string Name { get; set; }
        public string Address { get; set; }
        [JsonConverter(typeof(FlexibleDateConverter))]
        public DateTime? Birthday { get; set; }
        public DateTime? CreateDate { get; set; }
        public DateTime? UpdateDate { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string? Description { get; set; }

        public static async Task<Customer> GetCustomer(int id)
        {
            using (var connection = new SqlConnection(Connect.DefaultConnection))
            {
                await connection.OpenAsync();
                string query = "SELECT * FROM [Customer] WHERE Id = @Id";
                var customer = await connection.QueryFirstOrDefaultAsync<Customer>(query, new { Id = id });
                if (customer != null)
                {
                    customer.Phone = customer.Phone.Trim();
                }
                return customer;
            }
        }

        public static async Task<CustomerResponse> GetCustomers(int? pageNumber, int? pageSize, string? filter)
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
            SELECT COUNT(*) FROM [Customer] {where};
            SELECT * FROM [Customer] {where}
            ORDER BY Id
            OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";

                    parameters.Add("Offset", (pageNumber.Value - 1) * pageSize.Value);
                    parameters.Add("PageSize", pageSize.Value);
                }
                else
                {
                    query = $@"
            SELECT COUNT(*) FROM [Customer] {where};
            SELECT * FROM [Customer] {where}
            ORDER BY Id";
                }

                using (var multi = await connection.QueryMultipleAsync(query, parameters))
                {
                    int totalRecords = await multi.ReadFirstAsync<int>();
                    var customers = (await multi.ReadAsync<Customer>()).ToList();

                    foreach (var customer in customers)
                    {
                        if (customer.Phone != null)
                        {
                            customer.Phone = customer.Phone.Trim();
                        }
                    }

                    return new CustomerResponse
                    {
                        totalPage = pageSize.HasValue ? (int)Math.Ceiling(totalRecords / (double)pageSize.Value) : 1,
                        customers = customers
                    };
                }
            }
        }

        public static async Task<bool> AddCustomer(Customer newCustomer)
        {
            using (var connection = new SqlConnection(Connect.DefaultConnection))
            {
                await connection.OpenAsync();

                using (var transaction = connection.BeginTransaction())
                {
                    try
                    {
                        string query = @"
                    INSERT INTO [Customer] (Name, Address, Birthday, CreateDate, Email, Phone, Description)
                    VALUES (@Name, @Address, @Birthday, @CreateDate, @Email, @Phone, @Description);
                    SELECT CAST(SCOPE_IDENTITY() AS INT)";

                        var parameters = new
                        {
                            newCustomer.Name,
                            newCustomer.Address,
                            newCustomer.Birthday,
                            CreateDate = DateTime.Now,
                            newCustomer.Email,
                            newCustomer.Phone,
                            newCustomer.Description,
                        };

                        var customerId = await connection.ExecuteScalarAsync<int>(query, parameters, transaction);
                        transaction.Commit();
                        return customerId > 0;
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

        public static async Task<bool> UpdateCustomer(Customer updatedCustomer)
        {
            using (var connection = new SqlConnection(Connect.DefaultConnection))
            {
                await connection.OpenAsync();

                using (var transaction = connection.BeginTransaction())
                {
                    try
                    {
                        string query = @"
                    UPDATE [Customer]
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
                            updatedCustomer.Id,
                            updatedCustomer.Name,
                            updatedCustomer.Address,
                            updatedCustomer.Birthday,
                            UpdateDate = DateTime.Now,
                            updatedCustomer.Email,
                            updatedCustomer.Phone,
                            updatedCustomer.Description,
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

        public static async Task<bool> DeleteCustomer(int id)
        {
            using (var connection = new SqlConnection(Connect.DefaultConnection))
            {
                await connection.OpenAsync();

                using (var transaction = connection.BeginTransaction())
                {
                    try
                    {
                        string query = "DELETE FROM [Customer] WHERE Id = @Id";

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

    public class CustomerResponse
    {
        public int totalPage { get; set; }
        public List<Customer> customers { get; set; }
    }
}
