using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Web_api_pos_net_core6.Models;

namespace Web_api_pos_net_core6.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CustomerController : ControllerBase
    {
        [HttpPost]
        public async Task<IActionResult> PostCustomer([FromBody] Customer customer)
        {
            if (customer == null)
            {
                return BadRequest("Dữ liệu khách hàng không hợp lệ.");
            }

            try
            {
                bool isAdded = await Customer.AddCustomer(customer);
                if (isAdded)
                {
                    return Ok("Thêm khách hàng thành công.");
                }
                else
                {
                    return BadRequest("Thêm khách hàng thất bại.");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex);
            }
        }

        [HttpPut]
        public async Task<IActionResult> PutCustomer([FromBody] Customer customer)
        {
            if (customer == null)
            {
                return BadRequest("Dữ liệu khách hàng không hợp lệ.");
            }

            try
            {
                bool isUpdate = await Customer.UpdateCustomer(customer);
                if (isUpdate)
                {
                    return Ok("Cập nhật khách hàng thành công.");
                }
                else
                {
                    return BadRequest("Cập nhật khách hàng thất bại.");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex);
            }
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetCustomer(int id)
        {
            try
            {
                var customer = await Customer.GetCustomer(id);
                if (customer == null)
                {
                    return NotFound();
                }
                return Ok(customer);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex);
            }
        }

        [HttpGet]
        public async Task<IActionResult> GetCustomers(string? filter, int? pageNumber, int? pageSize)
        {
            try
            {
                if ((pageNumber.HasValue && !pageSize.HasValue) || (!pageNumber.HasValue && pageSize.HasValue))
                {
                    return BadRequest("pageNumber và pageSize đều phải có giá trị hoặc cả hai đều phải null.");
                }

                var customerResponse = await Customer.GetCustomers(pageNumber, pageSize, filter);
                return Ok(customerResponse);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }


        [HttpDelete]
        public async Task<IActionResult> DeleteCustomer(int id)
        {
            try
            {
                var success = await Customer.DeleteCustomer(id);
                if (!success)
                {
                    return NotFound();
                }
                return Ok("Xóa khách hàng thành công");
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex);
            }
        }
    }
}
