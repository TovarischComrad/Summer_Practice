using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task29
    {
        public static void Main()
        {
            int n = Convert.ToInt32(Console.ReadLine());
            string s = Console.ReadLine();
            string[] tmp = s.Split(' ');
            int[] arr = new int[n];
            for (int i = 0; i < n; i++)
            {
                arr[i] = Convert.ToInt32(tmp[i]);
            }

            int min = 101;
            for (int i = 0; i < n; i++)
            {
                min = Math.Min(min, arr[i]);
            }

            int count = 0;
            for (int i = 0; i < n; i++)
            {
                if (arr[i] == min) { count++; }
            }

            int[] mins = new int[count];
            int k = 0;
            for (int i = 0; i < n; i++)
            {
                if (arr[i] == min) {
                    mins[k] = i;
                    k++;
                }
            }

            Console.WriteLine(mins[(count - 1) / 2] + 1);
        }
    }
}
