using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task3
    {
        public static void Main()
        {
            int n;
            n = Convert.ToInt32(Console.ReadLine());

            string s = Console.ReadLine();
            string[] tmp = s.Split(' ');
            int[] a = new int[n];
            for (int i = 0; i < tmp.Length; i++)
            {
                a[i] = Convert.ToInt32(tmp[i]);
            }

            int sum = 0;
            int sign = 1;
            for (int i = 0; i < a.Length; i++)
            {
                sum += a[i] * sign;
                sign *= -1;
            }

            Console.WriteLine(sum);

        }
    }
}
