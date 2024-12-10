module day8;

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

//1. check if a A 0 get index
//2. check if a A 0 get index
//3. get index difference
//4. place # in that index difference - before place check if overlaps mark them with differnt value

struct IndexRowCol
{
	int y = 0;
	int x = 0;
	char value = '*';
}

void main()
{
	auto file = File("test8.txt", "r");
	auto result = file.byLine()
		.map!(line => line.strip().splitter("")
				.map!(c => c.idup.strip())
				.array)
		.array;

	// Use a built-in associative array. Key: char, Value: dynamic array of IndexRowCol
	IndexRowCol[][char] antennasByFreq;

	IndexRowCol* curr = new IndexRowCol;
	IndexRowCol* next = new IndexRowCol;
	next.value = '$'; // Initialize to something different

	// Scan the entire grid to find antennas
	bool reachedEnd = false;
	while (true)
	{
		reachedEnd = true;
		outer: for (int y = curr.y; y < cast(int) result.length; y++)
		{
			for (int x = curr.x; x < cast(int) result[y].length; x++)
			{
				if (!result[y][x].empty)
				{
					char c = result[y][x][0];
					if ((c >= '0' && c <= '9') ||
						(c >= 'a' && c <= 'z') ||
						(c >= 'A' && c <= 'Z'))
					{
						IndexRowCol ant;
						ant.x = x;
						ant.y = y;
						ant.value = c;
						antennasByFreq[c] ~= ant;
					}
				}
				reachedEnd = false;
			}
			curr.x = 0;
		}

		break;
	}

	writeln("Final result (the map):");
	writeln(result);

	struct Coord
	{
		int x, y;
		bool opEquals(const Coord other) const
		{
			return x == other.x && y == other.y;
		}

		size_t toHash() const
		{
			return typeid(int).getHash(&x) ^ (typeid(int).getHash(&y) * 31);
		}
	}

	Coord[string] antinodeSet;

	int height = cast(int) result.length;
	int width = (height > 0) ? cast(int) result[0].length : 0;

	foreach (freq; antennasByFreq.keys)
	{
		auto ants = antennasByFreq[freq];
		foreach (i; 0 .. ants.length)
		{
			foreach (j; i + 1 .. ants.length)
			{
				auto A = ants[i];
				auto B = ants[j];

				int Ax = A.x;
				int Ay = A.y;
				int Bx = B.x;
				int By = B.y;

				// Two antinodes:
				// P1 = 2A - B
				int P1x = 2 * Ax - Bx;
				int P1y = 2 * Ay - By;

				// P2 = 2B - A
				int P2x = 2 * Bx - Ax;
				int P2y = 2 * By - Ay;

				if (P1x >= 0 && P1x < width && P1y >= 0 && P1y < height)
					antinodeSet[format("%d:%d", P1x, P1y)] = Coord(P1x, P1y);

				if (P2x >= 0 && P2x < width && P2y >= 0 && P2y < height)
					antinodeSet[format("%d:%d", P2x, P2y)] = Coord(P2x, P2y);
			}
		}
	}

	writeln("Number of unique antinode locations: ", antinodeSet.length);
}
