using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task40
    {
        public static string Translate(string s)
        {
            string t = "";
            t += s[s.Length - 1];
            for (int i = 0; i < s.Length - 1; i++)
            {
                t += s[i];
            }
            return t;
        }

        public static bool Less(string s1, string s2)
        {
            for (int i = 0; i < s1.Length; i++)
            {
                if (s1[i] < s2[i]) { return true; }
                if (s1[i] > s2[i]) { return false; }
            }
            return false;
        }

        public static void Main()
        {
            string s = Console.ReadLine();
            string[] t = new string[s.Length];
            t[0] = s;
            for (int i = 1; i < s.Length; i++)
            {
                t[i] = Translate(t[i - 1]);
            }

            string min = "";
            for (int i = 0; i < s.Length; i++) { min += 'z'; }

            for (int i = 0; i < s.Length; i++)
            {
                if (Less(t[i], min))
                {
                    min = t[i];
                }
            }
            Console.WriteLine(min);
        }
    }
}
