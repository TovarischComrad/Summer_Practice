using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task6
    {
        public static void Main()
        {
            int n = Convert.ToInt32(Console.ReadLine());

            int d = (int)Math.Round((double)n / 3.0);
            int a = d / 12;
            int b = d % 12;

            Console.Write(a);
            Console.Write(" ");
            Console.WriteLine(b);
            
        }
    }
}
