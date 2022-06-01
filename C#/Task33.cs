using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task33
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

            int add = 1;
            int sum;

            for (int i = n - 1; i >= 0; i--)
            {
                sum = a[i] + add;
                a[i] = sum % 10;
                add = sum / 10;
            }

            Console.WriteLine(n + add); 
            if (add > 0)
            {
                Console.Write(add);
                Console.Write(' ');
            }
            for (int i = 0; i < n; i++)
            {
                Console.Write(a[i]);
                Console.Write(' ');
            }
            Console.WriteLine();
        }
    }
}
