using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task17
    {
        public static int del(int a)
        {
            int d = 0;
            for (int i = 1; i <= a / 2; i++)
            {
                if (a % i == 0)
                {
                    d++;
                }
            }
            return d + 1;
        }

        public static void Main()
        {
            string s = Console.ReadLine();  
            string[] tmp = s.Split(' ');
            int a = Convert.ToInt32(tmp[0]);
            int b = Convert.ToInt32(tmp[1]);

            int n = b - a + 1;
            int[] arr = new int[n];
            int max = -1;
            for (int i = 0; i < n; i++)
            {
                arr[i] = del(a + i);
                if (arr[i] > max) { max = arr[i]; } 
            }

            int d = 0;
            for (int i = 0; i < n; i++)
            {
                if (arr[i] == max)
                {
                    d++;
                }
            }
            Console.WriteLine(d);

            bool fl = true;
            for (int i = 0; i < n; i++)
            {
                if (arr[i] == max)
                {
                    if (fl) { fl = false; }
                    else { Console.Write(','); }
                    Console.Write(i + a);
                }
            }
            Console.WriteLine();
        }
    }
}
