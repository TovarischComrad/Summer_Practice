using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task41
    {
        public static bool Palindrome(string s, int l, int r)
        {
            int n = r - l + 1;
            for (int i = 0; i < n; i++)
            {
                if (s[l + i] != s[r - i]) { return false; }
            }
            return true;
        } 

        public static void Main()
        {
            string s = Console.ReadLine();
            bool fl = Palindrome(s, 0, s.Length - 1);
            for (int i = 0; i < s.Length; i++)
            {
                fl = fl || (Palindrome(s, 0, i) && Palindrome(s, i + 1, s.Length - 1));
                if (fl) { break; }
            }
            if (fl) { Console.WriteLine("YES"); }
            else { Console.WriteLine("NO"); }
        }
    }
}
