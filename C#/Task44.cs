using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task44
    {
        public static void Main()
        {
            int n = Convert.ToInt32(Console.ReadLine());
            Dictionary<char, string> dict = new Dictionary<char, string>();
            for (int i = 0; i < n; i++)
            {
                string s = Console.ReadLine();  
                string[] tmp = s.Split(' ');
                dict[tmp[0][0]] = tmp[1];
            }
            string code = Console.ReadLine();
            int k = 0;
            string t = "";
            string res = "";
            while (k < code.Length)
            {
                t += code[k];
                foreach (char c in dict.Keys)
                {
                    if (dict[c] == t)
                    {
                        res += c;
                        t = "";
                        break;
                    }
                }
                k++;
            }
            Console.WriteLine(res);
        }
    }
}
