using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task34
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

            int[] count = new int[n];
            int min, max;
            for (int i = 0; i < n; i++)
            {
                min = 10001;
                max = 0;
                for (int j = 0; j < n - i; j++)
                {
                    min = Math.Min(min, arr[j + i]);
                    max = Math.Max(max, arr[j + i]);
                    if (max - min > 1) { break; }
                    count[i]++;
                }
                if (count[i] == n) { break; }
            }

            max = 0;
            for (int i = 0; i < n; i++)
            {
                max = Math.Max(max, count[i]);
            }

            int l = 0;
            for (int i = 0; i < n; i++)
            {
                if (count[i] == max)
                {
                    l = i;
                    break;
                }
            }

            Console.Write(l + 1);
            Console.Write(' ');
            Console.WriteLine(max + l);
        }
    }
}
