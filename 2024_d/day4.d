module day4;

import std.stdio;
import std.file;
import std.string;
import std.array;
import std.algorithm;
import std.conv;
import std.range;
import std.math; 

//search right
//search left
//search diagnal
//search down

void main()
{
    auto result = readfile("test4.txt");

	int count=0;

	// part1
	// foreach (line; result)
	// {
	// 	 foreach (i; 0..line.length - 3) // Ensure there are at least 4 chars to check
    //     {
    //         if (line[i] == "X" &&
    //             line[i + 1] ==  "M" &&
    //             line[i + 2] == "A" &&
    //             line[i + 3] == "S")
    //         {
    //             count++;
    //         }
    //     }
	// }

	// // //search left
	// foreach (line; result)
    // {
    //     foreach (i; 3..line.length) // Start from 3 to avoid negative index
    //     {
    //         if (line[i] == "X" &&
    //             line[i - 1] == "M" &&
    //             line[i - 2] == "A" &&
    //             line[i - 3] == "S")
    //         {
    //             count++;
    //         }
    //     }
    // }

    // // //search down
    // for(int i = 0; i < result.length - 3; i++) 
    // {
    //     for(int j=0; j < result[i].length; j++) 
    //     {
    //         if(result[i][j] == "X" && result[i+1][j] == "M" && result[i+2][j] == "A" && result[i+3][j] == "S") {
    //             count++;
    //         }
    //     }
    // }

    // //up
    //  for(int i = 3; i < result.length; i++) 
    // {
    //     for(int j=0; j < result[i].length; j++) 
    //     {
    //         if(result[i][j] == "X" && result[i-1][j] == "M" && result[i-2][j] == "A" && result[i-3][j] == "S") {
    //             count++;
    //         }
    //     }
    // }

    // // //diagnal down right
    // for(int i = 0; i < result.length - 3; i++) 
    // {
    //     for(int j=0; j < result[i].length - 3; j++) 
    //     {
    //         if(result[i][j] == "X" && result[i+1][j+1] == "M" && result[i+2][j+2] == "A" && result[i+3][j+3] == "S") {
    //             count++;
    //         }
    //     }
    // }

    // // //diagnal down left
    // for(int i = 0; i < result.length - 3; i++) 
    // {
    //     for(int j=3; j < result[i].length; j++) 
    //     {
    //         if(result[i][j] == "X" && result[i+1][j-1] == "M" && result[i+2][j-2] == "A" && result[i+3][j-3] == "S") {
    //             count++;
    //         }
    //     }
    // }

    // // //diagnal up right
    // for(int i = 3; i < result.length; i++) 
    // {
    //     for(int j=0; j < result[i].length - 3; j++) 
    //     {
    //         if(result[i][j] == "X" && result[i-1][j+1] == "M" && result[i-2][j+2] == "A" && result[i-3][j+3] == "S") {
    //             count++;
    //         }
    //     }
    // }

    // // //diagnal up left
    // for(int i = 3; i < result.length; i++) 
    // {
    //     for(int j=3; j < result[i].length; j++) 
    //     {
    //         if(result[i][j] == "X" && result[i-1][j-1] == "M" && result[i-2][j-2] == "A" && result[i-3][j-3] == "S") {
    //             count++;
    //         }
    //     }
    // }

    //part2
    for (int i = 0; i < result.length - 2; i++)
    {
        for (int j = 0; j < result[i].length - 2; j++)
        {
            if (result[i][j] == "M" &&
                result[i][j + 2] == "S" &&
                result[i + 1][j + 1] == "A" &&
                result[i + 2][j] == "M" &&
                result[i + 2][j + 2] == "S")
            {
                count++;
            }

            if (result[i][j] == "S" &&
                result[i][j + 2] == "M" &&
                result[i + 1][j + 1] == "A" &&
                result[i + 2][j] == "S" &&
                result[i + 2][j + 2] == "M")
            {
                count++;
            }


             if (result[i][j] == "S" &&
                result[i][j + 2] == "S" &&
                result[i + 1][j + 1] == "A" &&
                result[i + 2][j] == "M" &&
                result[i + 2][j + 2] == "M")
            {
                count++;
            }

            if (result[i][j] == "M" &&
                result[i][j + 2] == "M" &&
                result[i + 1][j + 1] == "A" &&
                result[i + 2][j] == "S" &&
                result[i + 2][j + 2] == "S")
            {
                count++;
            }
        }
    }


    writeln(count);
}

auto readfile(string path)
{
    auto file = File(path, "r");

    auto result = file.byLine()
                      .map!(line => line.strip().splitter("").map!(c => c.idup).array) // Convert chars to strings
                      .array;

    return result; 
}