using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Web_api_pos_net_core6.Models;

namespace Web_api_pos_net_core6.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ItemController : ControllerBase
    {
        [HttpPost]
        public async Task<IActionResult> Post([FromBody] Item item)
        {
            if (item == null)
            {
                return BadRequest("Dữ liệu mặt hàng không hợp lệ.");
            }

            try
            {
                bool isAdded = await Item.AddItem(item);
                if (isAdded)
                {
                    return Ok("Thêm mặt hàng thành công.");
                }
                else
                {
                    return BadRequest("Thêm mặt hàng thất bại.");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpPut]
        public async Task<IActionResult> Put([FromBody] Item item)
        {
            if (item == null)
            {
                return BadRequest("Dữ liệu mặt hàng không hợp lệ.");
            }

            try
            {
                bool isUpdate = await Item.UpdateItem(item);
                if (isUpdate)
                {
                    return Ok("Cập nhật mặt hàng thành công.");
                }
                else
                {
                    return BadRequest("Cập nhật mặt hàng thất bại.");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Del(int id)
        {
            try
            {
                var success = await Item.DeleteItem(id);
                if (!success)
                {
                    return NotFound("Không tìm thấy mặt hàng.");
                }
                return Ok("Xóa mặt hàng thành công.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetItemById(int id)
        {
            try
            {
                var item = await Item.GetItem(id);
                if (item == null)
                {
                    return NotFound("Không tìm thấy mặt hàng.");
                }
                return Ok(item);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpGet("barcode/{barcode}")]
        public async Task<IActionResult> GetItemByBarcode(string barcode)
        {
            try
            {
                var item = await Item.GetItemByBarcode(barcode);
                if (item == null)
                {
                    return NotFound("Không tìm thấy mặt hàng.");
                }
                return Ok(item);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpGet]
        public async Task<IActionResult> GetItems(string? filter, int? groupId, int? pageNumber, int? pageSize, bool? sortByNewest = false, bool? inStock = false)
        {
            try
            {
                if ((pageNumber.HasValue && !pageSize.HasValue) || (!pageNumber.HasValue && pageSize.HasValue))
                {
                    return BadRequest("pageNumber và pageSize đều phải có giá trị hoặc cả hai đều phải null.");
                }
                var itemResponse = await Item.GetItems(pageNumber, pageSize, filter, inStock, groupId, sortByNewest ?? false);
                return Ok(itemResponse);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpGet("ItemGroup")]
        public async Task<IActionResult> GetGroups()
        {
            try
            {
                var groups = await ItemGroup.GetGroups();
                if (groups == null)
                {
                    return NotFound();
                }
                return Ok(groups);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpGet("Unit")]
        public async Task<IActionResult> GetUnits()
        {
            try
            {
                var units = await Unit.GetUnits();
                if (units == null)
                {
                    return NotFound();
                }
                return Ok(units);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

    }
}
