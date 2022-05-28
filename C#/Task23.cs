using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task23
    {
        public static bool find(int[] arr, int el)
        {
            for (int i = 0; i < arr.Length; i++)
            {
                if (arr[i] == el)
                {
                    return true;
                }
            }
            return false;
        }
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

            int m = Convert.ToInt32(Console.ReadLine());
            s = Console.ReadLine();
            tmp = s.Split(' ');
            int[] b = new int[m];
            for (int i = 0; i < m; i++)
            {
                b[i] = Convert.ToInt32(tmp[i]);
            }

            int count = 0;
            List<int> c = new List<int>();
            for (int i = 0; i < n; i++)
            {
                if (find(b, a[i]))
                {
                    c.Add(a[i]);
                    count++;
                }
            }

            Console.WriteLine(count);
            if (count > 0)
            {
                foreach (int i in c)
                {
                    Console.Write(i);
                    Console.Write(' ');
                }
            }
            Console.WriteLine();
            
        }
    }
}
