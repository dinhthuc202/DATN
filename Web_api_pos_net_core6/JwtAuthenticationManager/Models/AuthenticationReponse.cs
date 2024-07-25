namespace JwtAuthenticationManager.Models
{
    public class AuthenticationReponse
    {
        public string UserName { get; set; }
        public string JwtToken { get; set; }
        public int ExpiresIn { get; set; }
    }
}
