using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task1
    {
        public static void Main()
        {
            string s = Console.ReadLine();
            string[] tmp = s.Split(' ');

            int a = Convert.ToInt32(tmp[0]);
            int b = Convert.ToInt32(tmp[1]);

            Console.WriteLine(a + b);
        }
    }
}
