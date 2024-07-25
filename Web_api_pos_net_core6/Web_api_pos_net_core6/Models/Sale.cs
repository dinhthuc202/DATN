using Dapper;
using Microsoft.VisualBasic;
using System.Data.SqlClient;

namespace Web_api_pos_net_core6.Models
{
    public class Sale
    {
        public int? Id { get; set; }
        public DateTime? Date { get; set; }
        public bool? IsReturn { get; set; } = false;
        public int? CustomerId { get; set; }
        public string? CustomerName { get; set; }
        public int EmployeeId { get; set; }
        public string? EmployeeName { get; set; }
        public int? SaleQty { get; set; }
        public decimal? SaleAmount { get; set; }
        public int? SaleReturnQty { get; set; }
        public decimal? SaleReturnAmount { get; set; }
        public string? PaymentMethod { get; set; }
        public string? PaymentDetail { get; set; }
        public string? Remarks { get; set; }
        public List<SaleDetails> saleDetails { get; set; }

        public static async Task<bool> AddSale(Sale sale)
        {
            using (var connection = new SqlConnection(Connect.DefaultConnection))
            {
                await connection.OpenAsync();
                var transaction = connection.BeginTransaction();

                try
                {
                    string query = @"
            INSERT INTO [Sale] (Date, IsReturn, CustomerId, EmployeeId, SaleQty, SaleAmount, SaleReturnQty, SaleReturnAmount, PaymentMethod, PaymentDetail, Remarks)
            VALUES (@Date, @IsReturn, @CustomerId, @EmployeeId, @SaleQty, @SaleAmount, @SaleReturnQty, @SaleReturnAmount, @PaymentMethod, @PaymentDetail, @Remarks);
            SELECT CAST(SCOPE_IDENTITY() AS INT)";

                    sale.Date = DateTime.Now;
                    sale.SaleQty = 0;
                    sale.SaleAmount = 0;
                    sale.SaleReturnQty = 0;
                    sale.SaleReturnAmount = 0;
                    foreach (var item in sale.saleDetails)
                    {
                        if (sale.IsReturn == false)
                        {
                            //Bán hàng(trừ số lượng kho)
                            sale.SaleQty = sale.SaleQty + Math.Abs(item.Quantity);
                            sale.SaleAmount = sale.SaleAmount + Math.Abs(item.Quantity) * item.Price;
                        }
                        else
                        {
                            //Trả hàng (Thêm vào kho)
                            sale.SaleReturnQty = sale.SaleReturnQty + item.Quantity;
                            sale.SaleReturnAmount = sale.SaleReturnAmount + item.Quantity * item.Price;
                        }
                    }

                    var parameters = new
                    {
                        sale.Date,
                        sale.IsReturn,
                        sale.CustomerId,
                        sale.EmployeeId,
                        sale.SaleQty,
                        sale.SaleAmount,
                        sale.SaleReturnQty,
                        sale.SaleReturnAmount,
                        sale.PaymentMethod,
                        sale.PaymentDetail,
                        sale.Remarks,
                    };

                    var saleId = await connection.ExecuteScalarAsync<int>(query, parameters, transaction);

                    if (saleId > 0)
                    {
                        sale.Id = saleId;

                        if (sale.saleDetails != null && sale.saleDetails.Any())
                        {
                            await SaleDetails.AddSaleDetails(sale, transaction);
                        }

                        transaction.Commit();

                        return true;
                    }
                    else
                    {
                        transaction.Rollback();
                        return false;
                    }
                }
                catch (Exception)
                {
                    transaction.Rollback();
                    throw;
                }
            }
        }

        public static async Task<SaleResponse> GetSales(int? pageNumber, int? pageSize, string idFilter = null, bool? sortByNewest = false, DateTime? fromDate = null, DateTime? toDate = null, int? customerId = null, int? employeeId = null)
        {
            using (var connection = new SqlConnection(Connect.DefaultConnection))
            {
                await connection.OpenAsync();

                var whereClauses = new List<string>();
                var parameters = new DynamicParameters();

                if (fromDate.HasValue && toDate.HasValue)
                {
                    whereClauses.Add("Date BETWEEN @FromDate AND @ToDate");
                    parameters.Add("@FromDate", fromDate);
                    parameters.Add("@ToDate", toDate);
                }

                if (!string.IsNullOrEmpty(idFilter))
                {
                    whereClauses.Add("Id LIKE '%' + @IdFilter + '%'");
                    parameters.Add("@IdFilter", idFilter);
                }

                if (customerId.HasValue)
                {
                    whereClauses.Add("CustomerId = @CustomerId");
                    parameters.Add("@CustomerId", customerId);
                }

                if (employeeId.HasValue)
                {
                    whereClauses.Add("EmployeeId = @EmployeeId");
                    parameters.Add("@EmployeeId", employeeId);
                }

                string where = whereClauses.Count > 0 ? "WHERE " + string.Join(" AND ", whereClauses) : "";

                string orderBy = "ORDER BY Date";
                if (sortByNewest ?? false)
                {
                    orderBy += " DESC";
                }

                // Handle null pageNumber and pageSize
                int offset = 0;
                int limit = int.MaxValue; // Assume a large limit if not specified

                if (pageNumber.HasValue && pageSize.HasValue)
                {
                    offset = (pageNumber.Value - 1) * pageSize.Value;
                    limit = pageSize.Value;
                }

                string query = $@"
SELECT COUNT(*) FROM [Sale] {where};
SELECT * FROM [Sale] {where}
{orderBy}
OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";

                parameters.Add("@Offset", offset);
                parameters.Add("@PageSize", limit);

                using (var multi = await connection.QueryMultipleAsync(query, parameters))
                {
                    int totalRecords = await multi.ReadFirstAsync<int>();
                    var sales = (await multi.ReadAsync<Sale>()).ToList();

                    foreach (var item in sales)
                    {
                        query = "SELECT [Name] FROM [Users] WHERE Id = @EmployeeId";
                        item.EmployeeName = await connection.QueryFirstOrDefaultAsync<string>(query, new { EmployeeId = item.EmployeeId });

                        query = "SELECT [Name] FROM [Customer] WHERE Id = @CustomerId";
                        item.CustomerName = await connection.QueryFirstOrDefaultAsync<string>(query, new { CustomerId = item.CustomerId });

                        item.Remarks = item.Remarks != null ? item.Remarks.Trim() : null;
                        item.saleDetails = await SaleDetails.GetSaleDetails(item.Id.Value);
                    }

                    return new SaleResponse
                    {
                        totalPage = pageSize.HasValue ? (int)Math.Ceiling(totalRecords / (double)pageSize.Value) : 1,
                        sales = sales
                    };
                }
            }
        }

        public static async Task<List<DailySalesQuantity>> DailySalesQuantities(DateTime? fromDate, DateTime? toDate)
        {
            using (var connection = new SqlConnection(Connect.DefaultConnection))
            {
                await connection.OpenAsync();

                var whereClauses = new List<string>();
                var parameters = new DynamicParameters();

                if (fromDate.HasValue && toDate.HasValue)
                {
                    whereClauses.Add("s.Date BETWEEN @FromDate AND @ToDate");
                    parameters.Add("@FromDate", fromDate);
                    parameters.Add("@ToDate", toDate);
                }

                string where = whereClauses.Count > 0 ? "WHERE " + string.Join(" AND ", whereClauses) : "";

                string query = $@"
SELECT 
    CONVERT(DATE, s.Date) AS SaleDate,
    SUM(ABS(sd.Quantity)) AS TotalQuantitySold
FROM 
    [Pos_System].[dbo].[Sale] s
INNER JOIN 
    [Pos_System].[dbo].[SaleDetails] sd ON s.Id = sd.SaleId
{where}
GROUP BY 
    CONVERT(DATE, s.Date)
ORDER BY 
    SaleDate";

                var result = await connection.QueryAsync<DailySalesQuantity>(query, parameters);
                return result.ToList();
            }
        }

        public class DailySalesQuantity
        {
            public DateTime SaleDate { get; set; }
            public int TotalQuantitySold { get; set; }
        }
    }

    public class SaleDetails
    {
        public int? Id { get; set; }
        public int? SaleId { get; set; }
        public int ItemId { get; set; }
        public string? ItemName { get; set; }
        public int Quantity { get; set; }
        public decimal? Price { get; set; }
        public string? BatchNo { get; set; }

        public static async Task AddSaleDetails(Sale sale, SqlTransaction transaction)
        {
            try
            {
                foreach (var item in sale.saleDetails)
                {
                    string query = @"
                INSERT INTO [SaleDetails] (SaleId, ItemId, Quantity, Price, BatchNo)
                VALUES (@SaleId, @ItemId, @Quantity, @Price, @BatchNo)";

                    if (sale.IsReturn == false)
                    {
                        //Đặt giá trị thay đổi
                        item.Quantity = -Math.Abs(item.Quantity);
                    }

                    var parameters = new
                    {
                        SaleId = sale.Id,
                        item.ItemId,
                        item.Quantity,
                        item.Price,
                        item.BatchNo,
                    };

                    await transaction.Connection.ExecuteAsync(query, parameters, transaction);


                    WhsHistory history = new WhsHistory
                    {
                        ItemId = item.ItemId,
                        QuantityChange = item.Quantity,
                        ChangeType = sale.IsReturn.Value ? "Trả hàng bán" : "Bán hàng",
                        ChangeDate = sale.Date,
                        UserId = sale.EmployeeId,
                        Description = ""
                    };

                    await WhsHistory.AddWhsHistory(history, transaction);
                }
            }
            catch (Exception)
            {
                transaction.Rollback();
                throw;
            }
        }

        public static async Task<List<SaleDetails>> GetSaleDetails(int saleId)
        {
            using (var connection = new SqlConnection(Connect.DefaultConnection))
            {
                await connection.OpenAsync();
                string query = "SELECT * FROM [SaleDetails] WHERE SaleId = @Id";
                var saleDetails = (await connection.QueryAsync<SaleDetails>(query, new { Id = saleId })).ToList();
                foreach (var item in saleDetails)
                {
                    query = "SELECT [Name] FROM [Items] WHERE Id = @ItemId";
                    item.ItemName = await connection.QueryFirstOrDefaultAsync<string>(query, new { ItemId = item.ItemId });
                    item.BatchNo = item.BatchNo != null ? item.BatchNo.Trim() : null;
                }
                return saleDetails;
            }
        }
    }

    public class SaleResponse
    {
        public int totalPage { get; set; }
        public List<Sale> sales { get; set; }
    }
}
