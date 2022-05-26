using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task11
    {
        public static void Main()
        {
            int n = Convert.ToInt32(Console.ReadLine());
            if (n < 7)
            {
                Console.WriteLine("preschool child");
            }
            else if (n < 18)
            {
                Console.Write("schoolchild ");
                Console.WriteLine(n - 6);
            }
            else if (n < 23)
            {
                Console.Write("student ");
                Console.WriteLine(n - 17);
            }
            else
            {
                Console.Write("specialist");
            }
        }
    }
}
