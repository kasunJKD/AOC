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

void main()
{

	auto grid = readfile("test.txt");

	//left , right, down, up
	int[2][] dir = [[0, -1], [0, 1], [-1, 0], [1, 0]];

	bool inBounds(int y, int x)
	{
		return y >= 0 && x >= 0 && y < grid.length && x < grid[0].length;
	}

	bool findTrail(int y, int x, int currentHeight, ref bool[][] visited)
	{
		if (grid[y][x] == 9 && currentHeight == 9) // Reached height 9
			return true;

		visited[y][x] = true;

		foreach (d; dir)
		{
			int ny = y + d[0];
			int nx = x + d[1];
			if (inBounds(ny, nx) && !visited[ny][nx] && grid[ny][nx] == currentHeight + 1)
			{
				writeln("next", ny);
				writeln("next", nx);
				writeln("next val -", grid[ny][nx]);
				if (findTrail(ny, nx, currentHeight + 1, visited))
					return true;
			}
		}

		return false;
	}

	int totalScore = 0;

	foreach (y; 0 .. to!int(grid.length))
	{
		foreach (x; 0 .. to!int(grid[y].length))
		{
			if (grid[y][x] == 0) // Trailhead position
			{
				int trailScore = 0;

				bool[][] visited = new bool[][](to!int(grid.length), to!int(
						grid[0].length));

				visited = new bool[][](to!int(grid.length), to!int(
						grid[0].length));
				// Reset visited
				if (findTrail(y, x, 0, visited))
					trailScore++;

				totalScore += trailScore;
			}
		}
	}

	writeln(totalScore);

}

auto readfile(string path)
{
	auto file = File(path, "r");
	return file.byLine()
		.map!(line => line.strip().splitter("")
				.map!(c => to!int(c.idup)).array)
		.array;
}
