using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task15
    {
        public static bool prime(int a)
        {
            for (int i = 2; i < a / 2; i++)
            {
                if (a % i == 0)
                {
                    return false;
                }
            }
            return true;
        }

        public static void Main()
        {
            int n = Convert.ToInt32(Console.ReadLine());
            if (n > 1)
            {
                Console.WriteLine(2);
            }
            for (int i = 3; i <= n; i += 2)
            {
                if (prime(i))
                {
                    Console.WriteLine(i);
                }
            }
        }
    }
}
