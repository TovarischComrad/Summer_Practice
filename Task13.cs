using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task13
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

            int min = 10001;
            for (int i = 0; i < n; i++)
            {
                min = Math.Min(min, a[i]);
            }

            int count = 0;
            for (int i = 0; i < n; i++)
            {
                if (a[i] == min)
                {
                    count++;
                }
            }

            Console.WriteLine(count);
        }
    }
}
