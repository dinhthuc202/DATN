using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Web_api_pos_net_core6.Models;

namespace Web_api_pos_net_core6.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PurchaseController : ControllerBase
    {
        [HttpPost]
        public async Task<IActionResult> Post([FromBody] Purchase purchase)
        {
            if (purchase == null)
            {
                return BadRequest("Dũ liệu mua hàng không hợp lệ.");
            }

            try
            {
                bool isAdded = await Purchase.AddPurchase(purchase);
                if (isAdded)
                {
                    return Ok("Thêm mua hàng thành công");
                }
                else
                {
                    return BadRequest("Thêm mua hàng thất bại");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }
        [HttpGet]
        public async Task<IActionResult> Get(int? pageNumber, int? pageSize, string? filterId, bool? sortByNewest, DateTime? fromDate = null, DateTime? toDate = null, int? supplierId = null, int? employeeId = null)
        {
            try
            {
                if ((pageNumber.HasValue && !pageSize.HasValue) || (!pageNumber.HasValue && pageSize.HasValue))
                {
                    return BadRequest("pageNumber và pageSize đều phải có giá trị hoặc cả hai đều phải null.");
                }
                DateTime from = fromDate ?? DateTime.Parse("2000-01-01");
                DateTime to = toDate ?? DateTime.Now;

                var response = await Purchase.GetPurchases(pageNumber, pageSize, filterId, sortByNewest, from, to, supplierId, employeeId);
                return Ok(response);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }
    }
}
