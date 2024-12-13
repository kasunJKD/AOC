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

	auto newarr = "";
	auto id = 0;

	bool swaped = false;
	foreach (k, value; result)
	{
		if (k % 2 == 0)
		{
			if (value != 0)
			{
				newarr ~= ".".repeat(cast(size_t) value).array.join;
			}
		}
		else if (value != 0)
		{
			newarr ~= to!string(id).repeat(cast(size_t) value).array.join;
			id += 1;
		}
	}

	char[] arr = newarr.dup;
	auto placementpointer = 0;
	auto pickuppointer = arr.length - 1;

	while (placementpointer < pickuppointer)
	{
		while (arr[placementpointer] != '.' && placementpointer < pickuppointer)
		{
			placementpointer += 1;
		}
		while (arr[pickuppointer] == '.' && pickuppointer > placementpointer)
		{

			pickuppointer -= 1;
		}
		if (placementpointer == pickuppointer)
		{
			break;
		}
		auto blocktomove = arr[pickuppointer];
		arr[pickuppointer] = '.';
		pickuppointer -= 1;
		arr[placementpointer] = blocktomove;
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

	// writeln(newarr);
	// writeln(arr);
}
