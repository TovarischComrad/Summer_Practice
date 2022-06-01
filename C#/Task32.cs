using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task32
    {
        public static void Main()
        {
            int n = Convert.ToInt32(Console.ReadLine());
            string s = Console.ReadLine();
            string[] tmp = s.Split(' ');
            int[] a = new int[n];
            for (int i = 0; i < n; i++)
            {
                a[i] = Convert.ToInt32(tmp[i]);
            }

            int m = Convert.ToInt32(Console.ReadLine());
            s = Console.ReadLine();
            tmp = s.Split(' '); 
            int[] b = new int[m];
            for (int i = 0; i < m; i++)
            {
                b[i] = Convert.ToInt32(tmp[i]);
            }

            if (n < m)
            {
                Console.WriteLine(-1);
                return;
            }

            if (n > m)
            {
                Console.WriteLine(1);
                return;
            }

            for (int i = 0; i < n; i++)
            {
                if (a[i] < b[i])
                {
                    Console.WriteLine(-1);
                    return;
                }

                if (a[i] > b[i])
                {
                    Console.WriteLine(1);
                    return;
                }
            }

            Console.WriteLine(0);
            return;
        }
    }
}
