using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task2
    {
        public static void Main()
        {
            int n;
            n = Convert.ToInt32(Console.ReadLine());

            int[] a = new int[n];
            string s = Console.ReadLine();
            string[] tmp = s.Split(' ');
            for (int i = 0; i < tmp.Length; i++)
            {
                a[i] = Convert.ToInt32(tmp[i]); 
            }

            int sum = 0;
            for (int i = 0; i < a.Length; i++)
            {
                sum += a[i];
            }

            Console.WriteLine(sum);
        }
    }
}
