using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task4
    {
        public static void Main()
        {
            int y = Convert.ToInt32(Console.ReadLine());

            if (y % 4 == 0 && y % 100 != 0 || y % 400 == 0) 
            {
                Console.WriteLine(1);
            }
            else
            {
                Console.WriteLine(0);
            }
        }
    }
}
