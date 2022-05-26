using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task7
    {
        public static void Main()
        {
            int n = Convert.ToInt32(Console.ReadLine());
            int s = 0;
            while (true)
            {
                if (n % 2 == 0)
                {
                    s++;
                }
                else
                {
                    break;
                }
                n /= 2;
            }

            Console.WriteLine(s);
        }
    }
}
