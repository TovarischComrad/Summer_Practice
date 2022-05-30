using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task28
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

            int[] count = new int[5];
            for (int i = 0; i < n; i++)
            {
                count[arr[i]]++;
            }

            for (int i = 0; i < 5; i++)
            {
                if (count[i] > 0)
                {
                    Console.Write(i);
                    Console.Write(' ');
                    Console.WriteLine(count[i]);
                }    
            }
        }
    }
}
