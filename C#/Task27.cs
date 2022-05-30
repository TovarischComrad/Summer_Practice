using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task27
    {
        public static int[] Rotate(int[] arr, int l, int r)
        {
            int R = l + (r - l + 1) / 2;
            for (int i = l; i < R; i++)
            {
                int a = arr[i];
                arr[i] = arr[r - i + l];
                arr[r - i + l] = a;
            }
            return arr;
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

            s = Console.ReadLine();
            tmp = s.Split(' ');
            int l1 = Convert.ToInt32(tmp[0]) - 1;
            int r1 = Convert.ToInt32(tmp[1]) - 1;

            s = Console.ReadLine();
            tmp = s.Split(' ');
            int l2 = Convert.ToInt32(tmp[0]) - 1;
            int r2 = Convert.ToInt32(tmp[1]) - 1;

            arr = Rotate(Rotate(arr, l1, r1), l2, r2);

            for (int i = 0; i < n; i++)
            {
                Console.Write(arr[i]);
                Console.Write(' ');
            }
            Console.WriteLine();
        }
    }
}
