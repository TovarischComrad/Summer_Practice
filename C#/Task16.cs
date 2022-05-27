using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task16
    {
        public static void Main()
        {
            string s = Console.ReadLine();  
            string[] tmp = s.Split(' ');
            int a = Convert.ToInt32(tmp[0]);
            int b = Convert.ToInt32(tmp[1]);
            int c = Convert.ToInt32(tmp[2]);

            if (a == 0 && b == 0)
            {
                if (c == 0) { Console.WriteLine(-1); }
                else { Console.WriteLine(0); }
                return;
            }

            if (a == 0)
            {
                Console.WriteLine(1);
                return;
            }

            int d = b * b - 4 * a * c;
            if (d > 0)
            {
                Console.WriteLine(2);
            }
            else if (d == 0)
            {
                Console.WriteLine(1);
            }
            else
            {
                Console.WriteLine(0);
            }
        }
    }
}
