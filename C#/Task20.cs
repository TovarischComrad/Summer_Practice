using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task20
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

            int f, c;
            int j = 0;

            int max_f = 0;
            int max_c = 0;

            while (j < n)
            {
                c = 0;
                f = arr[j];
                while (arr[j] == f)
                {
                    c++;
                    j++;
                    if (j >= n)
                    {
                        break;
                    }
                }

                if (c > max_c)
                {
                    max_c = c;
                    max_f = f;
                }
            }
            Console.Write(max_f);
            Console.Write(' ');
            Console.WriteLine(max_c);
        }
    }
}
