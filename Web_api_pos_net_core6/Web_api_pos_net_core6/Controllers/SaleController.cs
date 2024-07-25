using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System;
using System.Net.Http;
using System.Threading.Tasks;
using Web_api_pos_net_core6.Models;

namespace Web_api_pos_net_core6.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SaleController : ControllerBase
    {
        private static readonly HttpClient client = new HttpClient();

        [HttpPost]
        public async Task<IActionResult> Post([FromBody] Sale sale)
        {
            if (sale == null)
            {
                return BadRequest("Dữ liệu bán hàng không hợp lệ.");
            }

            try
            {
                bool isAdded = await Sale.AddSale(sale);
                if (isAdded)
                {
                    return Ok("Thêm bán hàng thành công");
                }
                else
                {
                    return BadRequest("Thêm bán hàng thất bại");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpGet]
        public async Task<IActionResult> Get(int? pageNumber, int? pageSize, string? filterId, bool? sortByNewest, DateTime? fromDate = null, DateTime? toDate = null, int? customerId = null, int? employeeId = null)
        {
            try
            {
                if ((pageNumber.HasValue && !pageSize.HasValue) || (!pageNumber.HasValue && pageSize.HasValue))
                {
                    return BadRequest("pageNumber và pageSize đều phải có giá trị hoặc cả hai đều phải null.");
                }
                DateTime from = fromDate ?? DateTime.Parse("2000-01-01");
                DateTime to = toDate ?? DateTime.Now;

                var response = await Sale.GetSales(pageNumber, pageSize, filterId, sortByNewest, from, to, customerId, employeeId);
                return Ok(response);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpGet("daily-sales-quantity")]
        public async Task<IActionResult> GetDailySalesQuantitys(DateTime? fromDate = null, DateTime? toDate = null)
        {
            try
            {
                DateTime from = fromDate ?? DateTime.Parse("2000-01-01");
                DateTime to = toDate ?? DateTime.Now;

                var dailySalesQuantities = await Sale.DailySalesQuantities(from, to);
                return Ok(dailySalesQuantities);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpGet]
        [Route("GenerateQR")]
        public async Task<IActionResult> GenerateQRCodeAsync(double amount)
        {
            try
            {
                var url = "https://api.vietqr.io/v2/generate?x-client-id=dab29287-60c5-4a86-97d5-aae7a686442a&x-api-key=c7f46480-800e-48da-917c-e8e2bff01c16";
                var values = new JObject
                {
                    { "accountNo", "0846961712" },
                    { "accountName", "NGUYEN DINH THUC" },
                    { "acqId", "970418" },
                    { "amount", amount.ToString() },
                    { "addInfo", "Thanh toán hóa đơn" },
                    { "format", "text" },
                    { "template", "compact2" }
                };

                var content = new StringContent(values.ToString(), System.Text.Encoding.UTF8, "application/json");
                var response = await client.PostAsync(url, content);
                response.EnsureSuccessStatusCode();

                var responseString = await response.Content.ReadAsStringAsync();
                var decodedResponse = JObject.Parse(responseString);
                var base64DataUrl = decodedResponse["data"]["qrDataURL"].ToString().Split(',')[1];

                return Ok(base64DataUrl);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }
    }
}
