using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task10
    {
        public static void Main()
        {
            string s = Console.ReadLine();
            string[] tmp = s.Split(' ');
            int a = Convert.ToInt32(tmp[0]);
            int b = Convert.ToInt32(tmp[1]);

            int i = 0;
            while (a > 0 & b > 0)
            {
                if (a > b)
                {
                    i += a / b;
                    a = a % b;
                }
                else
                {
                    i += b / a;
                    b = b % a;
                }
            }

            Console.Write(i);
            Console.Write(" ");
            Console.WriteLine(Math.Max(a, b));
        }
    }
}
