using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task24
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

            int count = 0;
            for (int i = 0; i < n / 2; i++)
            {
                if (arr[i] != arr[n - i - 1])
                {
                    count++;
                }
            }
            Console.WriteLine(count);   
        }
    }
}
