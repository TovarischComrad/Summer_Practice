using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task5
    {
        public static void Main()
        {
            int n = Convert.ToInt32(Console.ReadLine());
            int[] a = new int[n];
            string s = Console.ReadLine();
            string[] tmp = s.Split(' ');
            for(int i = 0; i < tmp.Length; i++)
            {
                a[i] = Convert.ToInt32(tmp[i]);
            }

            int min = 10001;
            for (int i = 0; i < a.Length; i++)
            {
                min = Math.Min(min, a[i]);
            }

            for (int i = 0; i < a.Length; i++)
            {
                if (a[i] == min)
                {
                    Console.WriteLine(i + 1);
                    break;
                }
            }
        }
    }
}
