using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task31
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

            int[] count = new int[100];
            for (int i = 0; i < n; i++)
            {
                count[arr[i] - 1]++;
            }

            int num = 0;
            for (int i = 0; i < 100; i++)
            {
                if (count[i] > 1) { num++; }
            }

            Console.WriteLine(num);
            if (num > 0)
            {
                for (int i = 0; i < 100; i++)
                {
                    if (count[i] > 1)
                    {
                        Console.Write(i + 1);
                        Console.Write(' ');
                    }
                }
                Console.WriteLine();
            }
        }
    }
}
