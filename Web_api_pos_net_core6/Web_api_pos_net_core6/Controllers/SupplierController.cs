using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Web_api_pos_net_core6.Models;

namespace Web_api_pos_net_core6.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SupplierController : ControllerBase
    {
        [HttpPost]
        public async Task<IActionResult> Post([FromBody] Supplier supplier)
        {
            if (supplier == null)
            {
                return BadRequest("Dữ liệu nhà cung cấp không hợp lệ.");
            }

            try
            {
                bool isAdded = await Supplier.AddSupplier(supplier);
                if (isAdded)
                {
                    return Ok("Thêm nhà cung cấp thành công.");
                }
                else
                {
                    return BadRequest("Thêm nhà cung cấp thất bại.");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpPut]
        public async Task<IActionResult> PutSupplier([FromBody] Supplier supplier)
        {
            if (supplier == null)
            {
                return BadRequest("Dữ liệu nhà cung cấp không hợp lệ.");
            }

            try
            {
                bool isUpdate = await Supplier.UpdateSupplier(supplier);
                if (isUpdate)
                {
                    return Ok("Cập nhật nhà cung cấp thành công.");
                }
                else
                {
                    return BadRequest("Cập nhật nhà cung cấp thất bại.");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpGet]
        [Route("{id}")]
        public async Task<IActionResult> GetSupplier(int id)
        {
            try
            {
                var supplier = await Supplier.GetSupplier(id);
                if (supplier == null)
                {
                    return NotFound("Không tìm thấy nhà cung cấp.");
                }
                return Ok(supplier);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpGet]
        public async Task<IActionResult> GetSuppliers(int? pageNumber, int? pageSize, string? filter)
        {
            try
            {
                if ((pageNumber.HasValue && !pageSize.HasValue) || (!pageNumber.HasValue && pageSize.HasValue))
                {
                    return BadRequest("pageNumber và pageSize đều phải có giá trị hoặc cả hai đều phải null.");
                }

                var supplierResponse = await Supplier.GetSuppliers(pageNumber, pageSize, filter);
                return Ok(supplierResponse);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpDelete]
        public async Task<IActionResult> DeleteSupplier(int id)
        {
            try
            {
                var success = await Supplier.DeleteSupplier(id);
                if (!success)
                {
                    return NotFound("Không tìm thấy nhà cung cấp.");
                }
                return Ok("Xóa nhà cung cấp thành công.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }
    }
}
