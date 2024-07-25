using Dapper;
using JwtAuthenticationManager.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Data.SqlClient;
using Web_api_pos_net_core6.Models;
using Web_api_pos_net_core6.Models.Auth;

namespace Web_api_pos_net_core6.Controllers
{
    [ApiController]
    public class AccountController : ControllerBase
    {
        //private readonly JwtTokenHandler _jwtTokenHandler;
        //public AccountController(JwtTokenHandler jwtTokenHandler) {
        //    _jwtTokenHandler = jwtTokenHandler;
        //}

        private IConfiguration _config;
        public AccountController(IConfiguration config)
        {
            _config = config;
        }


        [Route("api/Login")]
        [HttpPost]
        public async Task<IActionResult> Login([FromBody] LoginDto user)
        {
            if (string.IsNullOrWhiteSpace(user.UserName) || string.IsNullOrWhiteSpace(user.Password))
            {
                return BadRequest("Invalid data");
            }

            try
            {
                using (var connection = new SqlConnection(Connect.DefaultConnection))
                {
                    await connection.OpenAsync();
                    string query = @"SELECT * FROM [Users] WHERE UserName = @UserName AND PassWord = @Password";

                    var encryptedPassword = Encryptor.MD5Hash(user.Password);
                    var result = await connection.QueryFirstOrDefaultAsync<User>(query, new { UserName = user.UserName, Password = encryptedPassword });

                    if (result != null)
                    {
                        result.Password = "";

    //                    var claims = new List<Claim> {
    //    new Claim(ClaimTypes.Name, user.UserName),
    //};
    //                    var jwtToken = new JwtSecurityToken(
    //                        claims: claims,
    //                        notBefore: DateTime.UtcNow,
    //                        expires: DateTime.UtcNow.AddDays(30),
    //                        signingCredentials: new SigningCredentials(
    //                            new SymmetricSecurityKey(
    //                               Encoding.UTF8.GetBytes("YourSecretKeyForAuthenticationOfApplication")
    //                                ),
    //                            SecurityAlgorithms.HmacSha256Signature)
    //                        );
    //                    var tmp = new JwtSecurityTokenHandler().WriteToken(jwtToken);

                        return Ok(result);


                       // return Ok(_jwtTokenHandler.GenerateJwtToken(result));
                    }
                    else
                    {
                        return Unauthorized();
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }
        [Route("api/Register")]
        [HttpPost]
        public async Task<IActionResult> Register([FromBody] User newUser)
        {
            if (newUser == null)
            {
                return BadRequest("Invalid data");
            }

            try
            {
                using (var connection = new SqlConnection(Connect.DefaultConnection))
                {
                    await connection.OpenAsync();

                    // Kiểm tra username đã tồn tại chưa
                    string checkQuery = @"SELECT COUNT(*) FROM [Users] WHERE UserName = @UserName";
                    var existingUsersCount = await connection.QueryFirstOrDefaultAsync<int>(checkQuery, new { UserName = newUser.UserName });

                    if (existingUsersCount > 0)
                    {
                        return StatusCode(409, "Username already exists");
                    }

                    //Insert new user
                    string insertQuery = @"
                        INSERT INTO [Users] (UserName, PassWord, Name, BirthDay, Mobile, Email, Address, CreateBy, TypeAccount, Status)
                        VALUES (@UserName, @Password, @Name, @BirthDay, @Mobile, @Email, @Address, @CreateBy, @TypeAccount, @Status);
                        SELECT CAST(SCOPE_IDENTITY() as int)";

                    newUser.Password = Encryptor.MD5Hash(newUser.Password);
                    var result = await connection.ExecuteAsync(insertQuery, newUser);

                    if (result > 0)
                    {
                        return Ok("Registration successful");
                    }
                    else
                    {
                        return StatusCode(500, "Failed to register user");
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [Route("api/UpdateUser")]
        [HttpPut]
        public async Task<IActionResult> UpdateUser([FromBody] User updatedUser)
        {
            if (updatedUser == null)
            {
                return BadRequest("Invalid data");
            }

            try
            {
                using (var connection = new SqlConnection(Connect.DefaultConnection))
                {
                    await connection.OpenAsync();

                    // Check if the user with the given id exists
                    string checkQuery = @"SELECT COUNT(*) FROM [Users] WHERE Id = @Id";
                    var existingUsersCount = await connection.QueryFirstOrDefaultAsync<int>(checkQuery, new { Id = updatedUser.Id });

                    if (existingUsersCount == 0)
                    {
                        return NotFound();
                    }

                    // Update user information
                    string updateQuery = @"
                        UPDATE [Users] SET 
                            UserName = @UserName,
                            Name = @Name,
                            Password = @Password,
                            BirthDay = @BirthDay,
                            Mobile = @Mobile,
                            Email = @Email,
                            Address = @Address,
                            TypeAccount = @TypeAccount,
                            Status = @Status
                        WHERE Id = @Id";

                    var result = await connection.ExecuteAsync(updateQuery, new
                    {
                        Id = updatedUser.Id,
                        UserName = updatedUser.UserName,
                        Password = Encryptor.MD5Hash(updatedUser.Password),
                        Name = updatedUser.Name,
                        BirthDay = updatedUser.BirthDay,
                        Mobile = updatedUser.Mobile,
                        Email = updatedUser.Email,
                        Address = updatedUser.Address,
                        TypeAccount = updatedUser.TypeAccount,
                        Status = updatedUser.Status,
                    });

                    if (result > 0)
                    {
                        return Ok("User updated successfully");
                    }
                    else
                    {
                        return StatusCode(500, "Failed to update user");
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [Route("api/User")]
        [HttpDelete,Authorize]
        public async Task<IActionResult> DelUser(int id)
        {
            using (var connection = new SqlConnection(Connect.DefaultConnection))
            {
                await connection.OpenAsync();

                using (var transaction = connection.BeginTransaction())
                {
                    try
                    {
                        string query = "DELETE FROM [Users] WHERE Id = @Id";

                        var parameters = new { Id = id };

                        var rowsAffected = await connection.ExecuteAsync(query, parameters, transaction);
                        transaction.Commit();
                        if (rowsAffected > 0)
                        {
                            return Ok("Delete successful");
                        }
                        else
                        {
                            return NotFound();
                        }
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        return StatusCode(500, ex);
                        throw;
                    }
                }
            }
        }
        [Route("api/GetUsers")]
        [HttpGet]
        public async Task<IActionResult> GetUsers(string? filter, string? typeAccount)
        {
            try
            {
                using (var connection = new SqlConnection(Connect.DefaultConnection))
                {
                    await connection.OpenAsync();

                    string query = "SELECT * FROM [Users] WHERE 1=1";

                    if (!string.IsNullOrEmpty(filter))
                    {
                        query += " AND (UserName LIKE @Filter OR Name LIKE @Filter OR Mobile LIKE @Filter OR Email LIKE @Filter)";
                    }

                    if (!string.IsNullOrEmpty(typeAccount))
                    {
                        query += " AND TypeAccount = @TypeAccount";
                    }

                    var parameters = new
                    {
                        Filter = $"%{filter}%",
                        TypeAccount = typeAccount
                    };

                    var users = (await connection.QueryAsync<User>(query, parameters)).ToList();

                    foreach (var user in users)
                    {
                        user.Password = null;
                    }

                    return Ok(users);
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [Route("api/GetUser/{id}")]
        [HttpGet]
        public async Task<IActionResult> GetUsers(int id)
        {
            try
            {

                using (var connection = new SqlConnection(Connect.DefaultConnection))
                {
                    await connection.OpenAsync();
                    string query = $"SELECT * FROM [Users] WHERE Id = {id}";
                    var user = await connection.QueryFirstOrDefaultAsync<User>(query);
                    if (user != null)
                    {
                        user.Password = null;
                    }
                    return Ok(user);
                }

            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }
    }
}
