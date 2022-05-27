using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task19
    {
        public static void Main()
        {
            int n = Convert.ToInt32(Console.ReadLine());
            int k = 0;
            int i = 1;
            int l = 1;
            while (l <= n)
            {
                k++;
                l += i;
                i++;
            }
            Console.WriteLine(k);
        }
    }
}
