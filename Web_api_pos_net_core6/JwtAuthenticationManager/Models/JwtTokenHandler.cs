using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace JwtAuthenticationManager.Models
{
    public class JwtTokenHandler
    {
        public JwtTokenHandler()
        {

        }
        public const string JWT_SECURITY_KEY = "Yh2k7QSu4l8CZg5p6X3Pna9L0Miy4D3Bvt0JVr87UcOj69Kqw5R2Nmf4FWs03Hdx";
        private const int JWT_TOKEN_VALIDITY_MINS = 20;

        public AuthenticationReponse GenerateJwtToken(User user)
        {
            var tokenExpiryTimeStamp = DateTime.Now.AddMinutes(JWT_TOKEN_VALIDITY_MINS);
            var tokenKey = Encoding.ASCII.GetBytes(JWT_SECURITY_KEY);
            var claimsIdentity = new ClaimsIdentity(new List<Claim> {
            new Claim("userName", user.UserName),
            new Claim("name", user.Name),
            new Claim("email", user.Email),
            new Claim("mobile", user.Mobile),
            new Claim("typeAccount", user.TypeAccount!),
            });

            var siningCredentials = new SigningCredentials(
                new SymmetricSecurityKey(tokenKey),
                SecurityAlgorithms.HmacSha256Signature);
            var securityTokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = claimsIdentity,
                Expires = tokenExpiryTimeStamp,
                SigningCredentials = siningCredentials,
            };
            var jwtSecurityTokenHander = new JwtSecurityTokenHandler();
            var securityToken = jwtSecurityTokenHander.CreateToken(securityTokenDescriptor);
            var token = jwtSecurityTokenHander.WriteToken(securityToken);

            return new AuthenticationReponse
            {
                UserName = "user name",
                ExpiresIn = (int)tokenExpiryTimeStamp.Subtract(DateTime.Now).TotalSeconds,
                JwtToken = token
            };
        }
    }
}
