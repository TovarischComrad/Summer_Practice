using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Csharp
{
    internal class Task46
    {
        static bool Rules(string[] board)
        {
            // Массив-счётчик корбалей
            int[] arr = new int[4];
            for (int i = 0; i < 4; i++) { arr[i] = 4 - i; }

            // Матрица посещений
            int[,] used = new int[10, 10];

            // Перебор строк доски
            for (int i = 0; i < 10; i++)
            {
                int k = 0;
                int l, n;
                int r = 0;
                bool hor;
                while (k < 10)
                {
                    while (k < 10 && (board[i][k] == '0' || used[i, k] == 1)) {
                        used[i, k] = 1;
                        k++; 
                    }
                    if (k < 10 && board[i][k] == '*')
                    {
                        // Определяем корабль
                        hor = true;
                        l = k;

                        // Горизонтальное расположение
                        if (k < 9 && board[i][k + 1] == '*')
                        {
                            l = k;
                            hor = true;
                            while (k < 10 && board[i][k] == '*') { 
                                used[i, k] = 1;
                                k++;
                            }
                            r = k;
                        }
                        // Вертикальное расположение
                        else if (i < 9 && board[i + 1][k] == '*')
                        {
                            hor = false;
                            int q = i;
                            l = q;
                            while (q < 10 && board[q][k] == '*')
                            {
                                used[q, k] = 1;
                                q++;
                            }
                            r = q;
                        }
                        else {
                            used[i, k] = 1;
                            k++;
                            r = l + 1;
                        }

                        n = r - l;
                        if (n > -1 && n <= 4) { arr[n - 1]--; }
                        else { return false; }
                        
                        // Проверяем границы
                        if (hor)
                        {
                            for (int p = Math.Max(0, i - 1); p <= Math.Min(9, i + 1); p++)
                            {
                                if (p == i) { continue; }
                                for (int t = Math.Max(0, l - 1); t < Math.Min(10, r + 1); t++)
                                {
                                    if (board[p][t] != '0') { return false; }
                                }
                            }
                        }
                        else
                        {
                            for (int p = Math.Max(0, l - 1); p < Math.Min(10, r + 1); p++)
                            {
                                for (int t = Math.Max(0, k - 1); t <= Math.Min(9, k + 1); t++)
                                {
                                    if (t == k) { continue; }
                                    if (board[p][t] != '0') { return false; }   
                                }
                            }
                        }
                    }
                }
            }
            for (int i = 0; i < 4; i++)
            {
                if (arr[i] != 0) { return false; }
            }
            return true;
        }

        static void Main(string[] args)
        {           
            int n = Convert.ToInt32(Console.ReadLine());
            string[] res = new string[n];
            for (int i = 0; i < n; i++)
            {
                string[] board = new string[10];
                for (int j = 0; j < 10; j++)
                {
                    board[j] = Console.ReadLine();
                }
                bool fl = Rules(board);
                if (fl) { res[i] = "YES"; }
                else { res[i] = "NO"; }
                if (i != n - 1) { Console.ReadLine(); }
            }
            for (int i = 0; i < n; i++)
            {
                Console.WriteLine(res[i]);
            }
        }
    }
}
