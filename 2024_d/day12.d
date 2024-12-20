// type A, B, and C plants are each in a region of area 4. The type E plants are in a region of area 3; the type D plants are in a region of area 1.
//sides x number of letter group
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

// Read the input grid from file
auto readfile(string path)
{
	auto file = File(path, "r");
	return file.byLine()
		.map!(line => line.strip().splitter("")
				.map!(c => to!string(c.idup)).array)
		.array;
}

bool inBounds(int x, int y, int rows, int cols)
{
	return x >= 0 && y >= 0 && x < rows && y < cols;
}

void floodFill(ref string[][] grid, int x, int y, string target, ref int area, ref int perimeter, ref bool[][] visited)
{
	int rows = to!int(grid.length);
	int cols = to!int(grid[0].length);

	// Directions (up, down, left, right)
	int[2][] directions = [[1, 0], [-1, 0], [0, 1], [0, -1]];

	// Queue for BFS
	Tuple!(int, int)[] queue;
	queue ~= tuple(x, y);
	visited[x][y] = true;

	while (!queue.empty)
	{
		auto curr = queue.front;
		queue.popFront();

		int cx = curr[0];
		int cy = curr[1];
		area++; // Count cell in area

		foreach (dir; directions)
		{
			int nx = cx + dir[0];
			int ny = cy + dir[1];

			// If out of bounds or different character, count as perimeter
			if (!inBounds(nx, ny, rows, cols) || grid[nx][ny] != target)
			{
				perimeter++;
			}
			// If not visited and part of the same region, add to queue
			else if (!visited[nx][ny])
			{
				visited[nx][ny] = true;
				queue ~= tuple(nx, ny);
			}
		}
	}
}

long calculateTotalPrice(ref string[][] grid)
{
	int rows = to!int(grid.length);
	int cols = to!int(grid[0].length);

	bool[][] visited = new bool[][](rows, cols);
	long totalPrice = 0;

	foreach (i; 0 .. rows)
	{
		foreach (j; 0 .. cols)
		{
			if (!visited[i][j])
			{
				string plant = grid[i][j];
				int area = 0;
				int perimeter = 0;

				floodFill(grid, i, j, plant, area, perimeter, visited);

				// Calculate price for this region
				long price = area * perimeter;
				totalPrice += price;
			}
		}
	}

	return totalPrice;
}

void main()
{
	auto grid = readfile("test.txt");
	long totalPrice = calculateTotalPrice(grid);
	writeln("Total Price: ", totalPrice);
}
