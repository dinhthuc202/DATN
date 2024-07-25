using System.Security.Cryptography;
using System.Text;

namespace Web_api_pos_net_core6.Models.Auth
{
    public class Encryptor
    {
        public static string MD5Hash(string text)
        {
            if (text == null) throw new ArgumentNullException(nameof(text));
            using (MD5 md5 = MD5.Create())
            {
                // Compute hash from the bytes of text
                byte[] hashBytes = md5.ComputeHash(Encoding.UTF8.GetBytes(text));

                // Convert the byte array to hexadecimal string
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < hashBytes.Length; i++)
                {
                    sb.Append(hashBytes[i].ToString("x2"));
                }

                return sb.ToString();
            }
        }

        public static string Encrypt(string strToEncrypt, string strKey)
        {
            try
            {
                using (TripleDES objDESCrypto =
                     TripleDES.Create())
                {
                    using (MD5 md5 = MD5.Create())
                    {
                        byte[] byteHash = md5.ComputeHash(Encoding.UTF8.GetBytes(strKey));
                        objDESCrypto.Key = byteHash;
                        objDESCrypto.Mode = CipherMode.ECB; //CBC, CFB
                        byte[] byteBuff = Encoding.UTF8.GetBytes(strToEncrypt);
                        return Convert.ToBase64String(objDESCrypto.CreateEncryptor()
                            .TransformFinalBlock(byteBuff, 0, byteBuff.Length));
                    }
                }
            }
            catch (Exception ex)
            {
                return "Wrong Input. " + ex.Message;
            }
        }

        public static string Decrypt(string strEncrypted, string strKey)
        {
            try
            {
                using (TripleDES objDESCrypto = TripleDES.Create())
                {
                    using (MD5 md5 = MD5.Create())
                    {
                        byte[] byteHash = md5.ComputeHash(Encoding.UTF8.GetBytes(strKey));
                        objDESCrypto.Key = byteHash;
                        objDESCrypto.Mode = CipherMode.ECB; //CBC, CFB
                        byte[] byteBuff = Convert.FromBase64String(strEncrypted);
                        string strDecrypted = Encoding.UTF8.GetString(objDESCrypto.CreateDecryptor()
                            .TransformFinalBlock(byteBuff, 0, byteBuff.Length));
                        return strDecrypted;
                    }
                }
            }
            catch (Exception ex)
            {
                return "Wrong Input. " + ex.Message;
            }
        }
    }

}
