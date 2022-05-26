using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task12
    {
        public static void Main()
        {
            string s = Console.ReadLine();
            string[] tmp = s.Split(' ');
            int a1 = Convert.ToInt32(tmp[0]);   
            int b1 = Convert.ToInt32(tmp[1]);

            s = Console.ReadLine();
            tmp = s.Split(' ');
            int a2 = Convert.ToInt32(tmp[0]);
            int b2 = Convert.ToInt32(tmp[1]);

            if (a1 == a2)
            {
                if (b1 + b2 == a1)
                {
                    Console.WriteLine("YES");
                    return;
                }
            }

            if (a1 == b2)
            {
                if (b1 + a2 == a1)
                {
                    Console.WriteLine("YES");
                    return;
                }
            }

            if (b1 == a2)
            {
                if (a1 + b2 == b1)
                {
                    Console.WriteLine("YES");
                    return;
                }
            }

            if (b1 == b2)
            {
                if (a1 + a2 == b1)
                {
                    Console.WriteLine("YES");
                    return;
                }
            }

            Console.WriteLine("NO");
            return;
        }
    }
}
