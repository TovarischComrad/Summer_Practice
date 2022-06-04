using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task43
    {
        public static void Main()
        {
            string xml = Console.ReadLine();
            int h = 0;
            for (int i = 0; i < xml.Length; i++)
            {
                if (xml[i] == '<')
                {    
                    if (xml[i + 1] == '/') { h--; }
                    for (int j = 0; j < 2 * h; j++) { Console.Write(' '); }
                    Console.Write(xml[i]);
                    h++;
                }
                else if (xml[i] == '>')
                {
                    Console.Write(xml[i]); 
                    Console.WriteLine();
                }
                else if (xml[i] == '/')
                {
                    Console.Write(xml[i]);
                    h--;
                }
                else { Console.Write(xml[i]); }
            }
        }
    }
}
