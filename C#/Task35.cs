using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task35
    {
        public static List<int> Div(int k)
        {
            List<int> list = new List<int>();
            for (int i = k; i >= 1; i--)
            {
                if (k % i == 0) { list.Add(i); }
            }
            return list;
        }

        public static bool Equal(int[] arr, int l, int k)
        {
            int n = arr.Length;
            if (l + k >= n) { return true; }
            for (int i = 0; i < k; i++)
            {
                if (arr[i + l] != arr[i + l + k]) { return false; } 
            }
            return true;
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

            int period = n;
            int m;
            bool fl;

            List<int> list = Div(n);
            foreach (int el in list)
            {
                m = n / el;
                fl = true;
                for (int i = 0; i < m; i++)
                {
                    fl &= Equal(arr, i * el, el);
                }
                if (fl) { period = el; }
            }
            Console.WriteLine(period);
        }
    }
}
