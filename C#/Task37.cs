using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task37
    {
        public static void Main()
        {
            string s = Console.ReadLine();
            int k = Convert.ToInt32(Console.ReadLine());

            if (k == 0)
            {
                Console.WriteLine(s);
                return; 
            }

            int i = 0;
            int j;
            string sub;
            bool fl = true;
            
            while (i < s.Length)
            {
                j = 0;
                sub = "";
                if (s[i] == ',')
                {
                    i++;
                    continue;
                }
                while (i < s.Length && s[i] != ',')
                {
                    sub += s[i];
                    i++;
                    j++;
                }
                if (j >= k)
                {
                    if (fl) {
                        fl = false;
                        Console.Write(sub);
                    }
                    else
                    {
                        Console.Write("," + sub);
                    }
                }
            }
            Console.WriteLine();
        }
    }
}
