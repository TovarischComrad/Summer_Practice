using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task21
    {
        public static int[] del(int[] arr)
        {
            int max = 0;
            for (int i = 0; i < arr.Length; i++)
            {
                max = Math.Max(max, arr[i]);
            }
            for (int i = 0; i < arr.Length; i++)
            {
                if (arr[i] == max)
                {
                    arr[i] /= 2;
                }
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

            arr = del(del(arr));
            for (int i = 0; i < n; i++)
            {
                Console.Write(arr[i]);
                Console.Write(" ");
            }    
            Console.WriteLine();
        }
    }
}
