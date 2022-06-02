using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task36
    {
        public static bool Strange(string s)
        {
            string vowels = "aeiouy";
            int i = 0;
            int k;
            while (i < s.Length)
            {
                k = 0;
                if (!vowels.Contains(s[i]))
                {
                    i++;
                    continue;
                }
                while (i < s.Length && vowels.Contains(s[i]))
                {
                    k++;
                    i++;
                }
                if (k >= 3) { return true; }
            }
            return false;
        }
        public static void Main()
        {
            int n = Convert.ToInt32(Console.ReadLine());
            string[] str = new string[n];
            for (int i = 0; i < n; i++)
            {
                str[i] = Console.ReadLine();
            }

            for (int i = 0; i < n; i++)
            {
                if (!Strange(str[i]))
                {
                    Console.WriteLine(str[i]);
                }
            }    
        }
    }
}
