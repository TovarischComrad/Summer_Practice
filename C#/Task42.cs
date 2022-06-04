using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task42
    {
        public static void Main()
        {
            string s = Console.ReadLine();
            string t = Console.ReadLine();

            bool fl;
            for (int i = 0; i <= s.Length - t.Length; i++)
            {
                fl = true;
                for (int j = 0; j < t.Length; j++)
                {
                    if (t[j] != '?' && t[j] != s[i + j])
                    {
                        fl = false;
                        break;
                    }
                }
                if (fl) { 
                    Console.Write(i + 1);
                    Console.Write(' ');
                }
            }
            Console.WriteLine();
        }
    }
}
