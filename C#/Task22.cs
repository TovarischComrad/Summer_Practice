using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task22
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
            for (int i = 0; i < n; i++)
            {
                for (int j = 0; j < n; j++)
                {
                    if (arr[j] % arr[i] == 0 && i != j)
                    {
                        count++;    
                    }
                }
            }
            Console.WriteLine(count);
        }
    }
}
