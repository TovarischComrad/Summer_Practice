using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task25
    {
        public static int RMQ(int[] arr, int l, int r)
        {
            int min = 101;
            for (int i = l - 1; i < r; i++)
            {
                min = Math.Min(min, arr[i]);
            }
            return min;
        }
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

            int m = Convert.ToInt32(Console.ReadLine());
            int[] p = new int[2 * m];
            for (int i = 0; i < m; i++)
            {
                s = Console.ReadLine();
                tmp = s.Split(' ');
                p[2 * i] = Convert.ToInt32(tmp[0]);
                p[2 * i + 1] = Convert.ToInt32(tmp[1]);
            }

            for (int i = 0; i < m; i++)
            {
                Console.WriteLine(RMQ(arr, p[2 * i], p[2 * i + 1]));
            }
        }
    }
}
