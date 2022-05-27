using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task18
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
            int sum = 0;
            int l = 0;
            int k = 1;
            int sign = 1;
            while (l < n)
            {
                for (int j = k; j > 0; j--)
                {
                    sum += arr[l] * sign;
                    l++;
                    if (l >= n)
                    {
                        break;
                    }
                }
                k++;
                sign *= -1;
            }    
            Console.WriteLine(sum);
        }
    }
}
