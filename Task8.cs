using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task8
    {
        public static void Main()
        {
            string s = Console.ReadLine();
            string[] tmp = s.Split(' ');
            int n = Convert.ToInt32(tmp[0]);
            int w = Convert.ToInt32(tmp[1]);

            s = Console.ReadLine();
            tmp = s.Split(' ');
            int[] a = new int[n];
            for (int i = 0; i < n; i++)
            {
                a[i] = Convert.ToInt32(tmp[i]);
            }


            int sum = 0;
            int count = 0;
            for (int i = 0; i < n; i++)
            {
                if (sum + a[i] <= w)
                {
                    count++;
                    sum += a[i];
                }
            }

            Console.Write(count);
            Console.Write(' ');
            Console.WriteLine(sum);   

        }
    }
}
