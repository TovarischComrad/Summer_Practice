using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task45
    {
        public static void Main()
        {
            string s = Console.ReadLine();
            string sign = ".,!?";
            string res = "";
            int i = 0;
            while (i < s.Length)    
            {
                if (s[i] == ' ')
                {
                    i++;
                    while (s[i] == ' ') { i++; }
                    if (!sign.Contains(s[i])) { res += " "; }
                    else { 
                        res += s[i] + " ";
                        i++;
                        while (s[i] == ' ' || sign.Contains(s[i])) { i++; }
                    }
                }
                else if (sign.Contains(s[i]))
                {
                    res += s[i] + " ";
                    i++;
                    while (s[i] == ' ' || sign.Contains(s[i])) { i++; }
                }
                else
                {
                    res += s[i];
                    i++;
                }
            }
            Console.WriteLine(res);
        }
    }
}
