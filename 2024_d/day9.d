module day9;

import std.stdio;
import std.file;
import std.string;
import std.array;
import std.algorithm;
import std.conv;
import std.range;
import std.math;
import std.algorithm.searching;
import std.container;
import std.ascii;
import std.utf;
import std.typecons;
import std.uni;
import std.traits;

//12345 1file 2freespace 3file 4free 5file
//	0       ..        111  ....   22222

void main()
{
	auto file = File("test9.txt", "r");
	// 'join' flattens the array of arrays into a single array of longs
	auto result = file.byLine()
		.map!(line => line.strip()
				.splitter("")
				.map!(v => to!long(v.idup.strip()))
				.array)
		.array
		.join; // result is a long[]

	// Make newarr a string so we can append string data to it.
	auto newarr = "";
	auto id = 0;

	bool swaped = false;
	foreach (k, value; result)
	{
		if (swaped)
		{
			if (value != 0)
			{
				// Convert the repeat range to a string with .array
				newarr ~= ".".repeat(cast(size_t) value).array.join;
			}
			swaped = false;
		}
		else
		{
			if (value != 0)
			{
				// If you want to print the digit itself, use `value`:
				// newarr ~= to!string(value).repeat(cast(size_t) value).array;

				// If you want to print the index `k`, use this:
				newarr ~= to!string(id).repeat(cast(size_t) value).array.join;
				id += 1;
			}
			swaped = true;
		}
	}

	char[] arr = newarr.dup;
	//move right to left
	foreach (l; 0 .. arr.length)
	{
		foreach_reverse(i, r;arr)
		{
			if (arr[l] == '.' && i>l)
			{
				arr[l] = r;
				arr[i] = '.';
				break;
			}
		}
	}

 long checksum = 0;
    foreach (i, c; arr)
    {
        if (c != '.')
        {
            int fileID = c - '0'; // Convert character digit to integer file ID
            checksum += i * fileID;
        }
    }

    writeln("Checksum: ", checksum);

	//writeln(newarr);
	//writeln(arr);
}
