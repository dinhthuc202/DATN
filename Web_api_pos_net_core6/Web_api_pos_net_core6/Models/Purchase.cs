using Dapper;
using Microsoft.VisualBasic;
using System.Data.SqlClient;

namespace Web_api_pos_net_core6.Models
{
    public class Purchase
    {
        public int? Id { get; set; }
        public DateTime? Date { get; set; }
        public bool? IsReturn { get; set; }
        public int SupplierId { get; set; }
        public string? SupplierName { get; set; }
        public int EmployeeId { get; set; }
        public string? EmployeeName { get; set; }
        public int? PurchaseQty { get; set; }
        public decimal? PurchaseAmount { get; set; }
        public int? PurchaseReturnQty { get; set; }
        public decimal? PurchaseReturnAmount { get; set; }
        public string? PaymentMethod { get; set; }
        public string? PaymentDetails { get; set; }
        public string? Remarks { get; set; }
        public List<PurchaseDetails> purchaseDetails { get; set; }

        public static async Task<bool> AddPurchase(Purchase purchase)
        {
            using (var connection = new SqlConnection(Connect.DefaultConnection))
            {
                await connection.OpenAsync();
                var transaction = connection.BeginTransaction();

                try
                {
                    string query = @"
            INSERT INTO [Purchase] (Date, IsReturn, SupplierId, EmployeeId, PurchaseQty, PurchaseAmount, PurchaseReturnQty, PurchaseReturnAmount, PaymentMethod, PaymentDetails, Remarks)
            VALUES (@Date, @IsReturn, @SupplierId, @EmployeeId, @PurchaseQty, @PurchaseAmount, @PurchaseReturnQty, @PurchaseReturnAmount, @PaymentMethod, @PaymentDetails, @Remarks);
            SELECT CAST(SCOPE_IDENTITY() AS INT)";

                    purchase.Date = DateTime.Now;
                    purchase.PurchaseQty = 0;
                    purchase.PurchaseAmount = 0;
                    purchase.PurchaseReturnQty = 0;
                    purchase.PurchaseReturnAmount = 0;
                    foreach (var item in purchase.purchaseDetails)
                    {
                        if (purchase.IsReturn == true)
                        {
                            //trả hàng
                            purchase.PurchaseReturnQty = purchase.PurchaseReturnQty + Math.Abs(item.Quantity);
                            purchase.PurchaseReturnAmount = purchase.PurchaseReturnAmount + Math.Abs(item.Quantity) * item.Price;
                        }
                        else
                        {
                            purchase.PurchaseQty = purchase.PurchaseQty + item.Quantity;
                            purchase.PurchaseAmount = purchase.PurchaseAmount + item.Quantity * item.Price;
                        }
                    }

                    var parameters = new
                    {
                        purchase.Date,
                        purchase.IsReturn,
                        purchase.SupplierId,
                        purchase.EmployeeId,
                        purchase.PurchaseQty,
                        purchase.PurchaseAmount,
                        purchase.PurchaseReturnQty,
                        purchase.PurchaseReturnAmount,
                        purchase.PaymentMethod,
                        purchase.PaymentDetails,
                        purchase.Remarks,
                    };

                    var purchaseId = await connection.ExecuteScalarAsync<int>(query, parameters, transaction);

                    if (purchaseId > 0)
                    {
                        purchase.Id = purchaseId;

                        if (purchase.purchaseDetails != null && purchase.purchaseDetails.Any())
                        {
                            await PurchaseDetails.AddPurchaseDetails(purchase, transaction);
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

        public static async Task<PurchaseResponse> GetPurchases(int? pageNumber, int? pageSize, string idFilter = null, bool? sortByNewest = false, DateTime? fromDate = null, DateTime? toDate = null, int? supplierId = null, int? employeeId = null)
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

                if (supplierId.HasValue)
                {
                    whereClauses.Add("SupplierId = @SupplierId");
                    parameters.Add("@SupplierId", supplierId);
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
SELECT COUNT(*) FROM [Purchase] {where};
SELECT * FROM [Purchase] {where}
{orderBy}
OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";

                parameters.Add("@Offset", offset);
                parameters.Add("@PageSize", limit);

                using (var multi = await connection.QueryMultipleAsync(query, parameters))
                {
                    int totalRecords = await multi.ReadFirstAsync<int>();
                    var purchases = (await multi.ReadAsync<Purchase>()).ToList();

                    foreach (var item in purchases)
                    {
                        query = "SELECT [Name] FROM [Users] WHERE Id = @EmployeeId";
                        item.EmployeeName = await connection.QueryFirstOrDefaultAsync<string>(query, new { EmployeeId = item.EmployeeId });

                        query = "SELECT [Name] FROM [Supplier] WHERE Id = @SupplierId";
                        item.SupplierName = await connection.QueryFirstOrDefaultAsync<string>(query, new { SupplierId = item.SupplierId });

                        item.Remarks = item.Remarks != null ? item.Remarks.Trim() : null;
                        item.purchaseDetails = await PurchaseDetails.GetPurchaseDetails(item.Id.Value);
                    }

                    return new PurchaseResponse
                    {
                        totalPage = pageSize.HasValue ? (int)Math.Ceiling(totalRecords / (double)pageSize.Value) : 1,
                        purchases = purchases
                    };
                }
            }
        }
    }

    public class PurchaseDetails
    {
        public int? Id { get; set; }
        public int? PurchaseId { get; set; }
        public int? ItemId { get; set; }
        public string? ItemName { get; set; }
        public int Quantity { get; set; }
        public decimal? Price { get; set; }
        public string? BatchNo { get; set; }

        public static async Task AddPurchaseDetails(Purchase purchase, SqlTransaction transaction)
        {
            try
            {
                foreach (var item in purchase.purchaseDetails)
                {
                    string query = @"
                INSERT INTO [PurchaseDetails] (PurchaseId, ItemId, Quantity, Price, BatchNo)
                VALUES (@PurchaseId, @ItemId, @Quantity, @Price, @BatchNo)";

                    if (purchase.IsReturn == true)
                    {
                        //Đặt về giá trị thay đổi 
                        item.Quantity = -Math.Abs(item.Quantity);
                    }

                    var parameters = new
                    {
                        PurchaseId = purchase.Id,
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
                        ChangeType = purchase.IsReturn.Value ? "Trả hàng mua" : "Mua hàng",
                        ChangeDate = purchase.Date,
                        UserId = purchase.EmployeeId,
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

        public static async Task<List<PurchaseDetails>> GetPurchaseDetails(int PurchaseId)
        {
            using (var connection = new SqlConnection(Connect.DefaultConnection))
            {
                await connection.OpenAsync();
                string query = "SELECT * FROM [PurchaseDetails] WHERE PurchaseId = @Id";
                var purchaseDetails = (await connection.QueryAsync<PurchaseDetails>(query, new { Id = PurchaseId })).ToList();
                foreach (var item in purchaseDetails)
                {
                    query = "SELECT [Name] FROM [Items] WHERE Id = @ItemId";
                    item.ItemName = await connection.QueryFirstOrDefaultAsync<string>(query, new { ItemId = item.ItemId });
                    item.BatchNo = item.BatchNo != null ? item.BatchNo.Trim() : null;
                }
                return purchaseDetails;
            }
        }
    }

    public class PurchaseResponse
    {
        public int totalPage { get; set; }
        public List<Purchase> purchases { get; set; }
    }
}
