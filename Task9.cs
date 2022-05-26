using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task9
    {
        public static void Main()
        {
            int n = Convert.ToInt32(Console.ReadLine());
            string s = Console.ReadLine();
            string[] tmp = s.Split(' ');
            int[] a = new int[n];
            for (int i = 0; i < tmp.Length; i++)
            {
                a[i] = Convert.ToInt32(tmp[i]);
            }

            int sum = 0;
            for (int i = 1; i <= a.Length; i *= 2)
            {
                sum += a[i - 1];
            }

            Console.WriteLine(sum);
        }
        

    }
}
