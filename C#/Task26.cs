using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task26
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

            for (int i = 0; i < n; i++)
            {
                int k = i + 1;
                while (k < n && arr[k] <= arr[i])
                {
                    k++;
                }
                if (k == n)
                {
                    arr[i] = 0;
                }
                else
                {
                    arr[i] = arr[k];
                }
            }

            for (int i = 0; i < n; i++)
            {
                Console.Write(arr[i]);
                Console.Write(" ");
            }
            Console.WriteLine();
        } 
    }
}
