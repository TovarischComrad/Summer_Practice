using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task39
    {
        public static bool Letter(char c)
        {
            if (c >= 65 && c <= 90 || c >= 97 && c <= 122) { return true; }
            else { return false; }
        }

        public static void Main()
        {
            string s = Console.ReadLine();
            int i = 0;
            int j;
            int k = 0;
            while (i < s.Length)
            {
                j = 0;
                if (!Letter(s[i]))
                {
                    i++;
                    continue;
                }
                while (i < s.Length && Letter(s[i]))
                {
                    j++;
                    i++;
                }
                if (j > 0) { k++; }
            }
            Console.WriteLine(k);
        }
    }
}
