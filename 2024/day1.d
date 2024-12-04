module day1;

import std.stdio;
import std.file;
import std.string;
import std.array;
import std.algorithm;
import std.conv;
import std.range;
import std.math; 

void main()
{
	auto result = readfile("test1_input.txt");

	auto left = result.map!(values => values[0]).array;
	auto right = result.map!(values => values[1]).array;

	left.sort();
	right.sort();

	//1st part==>
	//auto newResults = left.zip(right).map!(t => [t[0], t[1]]).array;

	// auto total = 0;
	// foreach (value; newResults)
	// {
	// 	int diff=0;
	// 	if (value[0] > value[1])
	// 	{
	// 		diff = value[0] - value[1];
	// 	}
	// 	else if (value[1] > value[0])
	// 	{
	// 		diff = value[1] - value[0];
	// 	}

	// 	total += diff;
	// }
	// auto total = 0;
	// foreach (value; newResults)
	// {
	// 	int diff = abs(value[0] - value[1]);
	// 	total += diff;
	// }
	

	//2nd part==>
	int total = 0;

	foreach (lv; left)
	{
		int count=0;
		foreach (rv; right)
		{
			if(lv==rv){
				count++;
			}
		}

		total+=count*lv;
		
	}

	writeln(total);
}

int[][] readfile(string path)
{
	auto file = File(path, "r");

	auto result = file.byLine().map!(line => line.strip.split).map!(tokens => [to!int(tokens[0]), to!int(tokens[1])]).array;

	//writeln(result);
	return result;
}


//[[v1, v2], [v1,v2]]