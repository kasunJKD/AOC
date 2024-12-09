module day6;

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
import std.typecons;

//gured rule 
//1. if # infront guard turn 90 to RIGHT
//2. else foward to the guard looking direction

//do this until gueard goes off the grid margin

//replace . with X and check it and count

// Directions in order: Up, Right, Down, Left

// Read the grid from a file
auto readfile(string path) {
    auto file = File(path, "r");
    return file.byLine()
               .map!(line => line.strip().splitter("").map!(c => c.idup).array)
               .array;
}

enum CellObstacle = "#";
enum CellVisited = "X";
enum CellEmpty = ".";
enum CellLooperBlock = "O";

void main() {
    auto grid = readfile("test6.txt");

    // Find starting position and direction
    int startX = -1;
    int startY = -1;
    int initialX = -1;
    int initialY = -1;
    int dirIndex = 0; 
    int initialDirIndex=0;
    // Directions as deltas and in order: Up, Right, Down, Left
    int[2][] directions = [[-1, 0],
                       [ 0, 1],
                       [ 1, 0],
                       [ 0,-1]];

    // Find the guard's start
    bool found = false;
    for (int x = 0; x < grid.length && !found; x++) {
        for (int y = 0; y < grid[x].length && !found; y++) {
            if (grid[x][y] == "^") {
                startX = x; startY = y; dirIndex = 0; found = true;
            } else if (grid[x][y] == ">") {
                startX = x; startY = y; dirIndex = 1; found = true;
            } else if (grid[x][y] == "v") {
                startX = x; startY = y; dirIndex = 2; found = true;
            } else if (grid[x][y] == "<") {
                startX = x; startY = y; dirIndex = 3; found = true;
            }
        }
    }

    if(!found) {
        writeln("No guard found on the map.");
        return;
    }

    // Mark the starting position as visited
    grid[startX][startY] = CellVisited;
    initialX = startX;
    initialY = startY;
    initialDirIndex = dirIndex;

    int curX = startX;
    int curY = startY;

    int loopDetected = 0;

    // Simulation loop
    while (true) {
        // Check what's in front
        int nx = curX + directions[dirIndex][0];
        int ny = curY + directions[dirIndex][1];

        // Check if outside grid
        bool outside = nx < 0 || nx >= grid.length || ny < 0 || ny >= grid[nx].length;

        if (outside) {
            // Guard leaves the mapped area
            break;
        }

        auto frontCell = grid[nx][ny];

        if(curX == initialX && curY == initialY && dirIndex == initialDirIndex)
        {
            loopDetected++;
        }

        // If obstacle in front
        if (frontCell == CellObstacle) {
            // Turn right: (dirIndex + 1) % 4
            dirIndex = (dirIndex + 1) % 4;
            // Don't move forward, just change direction
        } else {
            // Move forward if not obstacle
            // The cell could be ".", "X", or possibly empty space
            curX = nx;
            curY = ny;
            // Mark visited
            grid[curX][curY] = CellVisited;
        }
    }

    // Count distinct visited positions
    int visitedCount = 0;
    foreach (row; grid) {
        foreach (cell; row) {
            if (cell == CellVisited) visitedCount++;
        }
    }

    writeln(loopDetected);
}


//part2
// enum CellObstacle = "#";
// enum CellVisited = "X";
// enum CellEmpty = ".";
// enum CellUp = "^";
// enum CellRight = ">";
// enum CellDown = "v";
// enum CellLeft = "<";
// struct Direction {
//     // Directions in order: Up, Right, Down, Left
//     static int[2][] deltas = [[-1,0],[0,1],[1,0],[0,-1]];
//     static string[] symbols = [CellUp, CellRight, CellDown, CellLeft];
// }

// struct State {
//     int x, y, dirIndex;
//     bool opEquals(ref const State other) const {
//         return x == other.x && y == other.y && dirIndex == other.dirIndex;
//     }
//     size_t toHash() const {
//         size_t result = 0;
//         result = (result * 31) + x;
//         result = (result * 31) + y;
//         result = (result * 31) + dirIndex;
//         return result;
//     }
// }

// struct SimulationResult {
//     bool loop;
//     bool exited;
// }

// auto readfile(string path) {
//     auto file = File(path, "r");
//     return file.byLine()
//                .map!(line => line.strip().splitter("")
//                                  .map!(c => c.idup)
//                                  .array)
//                .array;
// }

// SimulationResult simulate(ref string[][] grid, int startX, int startY, int startDirIndex) {
//     int x = startX;
//     int y = startY;
//     int dirIndex = startDirIndex;

//     grid[x][y] = CellVisited;
//     State[] visitedStates;
//     int stepCount = 0;

//     while (true) {
//         if (stepCount++ > 1_000_000) {
//             writeln("Stopping after 1,000,000 steps. Check your logic.");
//             return SimulationResult(false, false); // Arbitrary return
//         }

//         State currentState = State(x, y, dirIndex);
        
//         // Debug print
//         // writeln("x=", x, " y=", y, " dir=", dirIndex, " grid[x][y]=", grid[x][y]);

//         if (visitedStates.canFind(currentState)) {
//             return SimulationResult(true, false); // loop detected
//         } else {
//             visitedStates ~= currentState;
//         }

//         int nx = x + Direction.deltas[dirIndex][0];
//         int ny = y + Direction.deltas[dirIndex][1];

//         // Check bounds
//         if (nx < 0 || nx >= grid.length || ny < 0 || ny >= grid[nx].length) {
//             return SimulationResult(false, true); // exited
//         }

//         auto frontCell = grid[nx][ny];

//         if (frontCell == CellObstacle) {
//             dirIndex = (dirIndex + 1) % 4; // turn right
//         } else {
//             x = nx;
//             y = ny;
//             grid[x][y] = CellVisited;
//         }
//     }
// }

// void main() {
//     auto grid = readfile("test6.txt");

//     int startX = -1;
//     int startY = -1;
//     int startDirIndex = 0;
//     bool found = false;

//     // Find starting position & direction
//     for (int i = 0; i < grid.length && !found; i++) {
//         for (int j = 0; j < grid[i].length && !found; j++) {
//             auto cell = grid[i][j];
//             auto idx = cast(int)Direction.symbols.countUntil(cell);
//             if (idx < Direction.symbols.length) {
//                 startX = i;
//                 startY = j;
//                 startDirIndex = idx;
//                 found = true;
//             }
//         }
//     }

//     if (!found) {
//         writeln("No guard found on the map.");
//         return;
//     }

//     // The guard starts on a direction cell, mark visited
//     grid[startX][startY] = CellVisited;

//     // Optional: test original configuration
//     {
//         auto originalGrid = grid.map!(r => r.dup).array;
//         auto res = simulate(originalGrid, startX, startY, startDirIndex);
//         // Not required to do anything with this result
//     }

//     int loopCount = 0;

//     // Try placing an obstruction on each cell
//     for (int i = 0; i < grid.length; i++) {
//         for (int j = 0; j < grid[i].length; j++) {
//             if (i == startX && j == startY) continue; // can't place where guard started
//             if (grid[i][j] == CellObstacle) continue; // already obstacle

//             auto backup = grid[i][j];
//             grid[i][j] = CellObstacle;

//             auto testGrid = grid.map!(r => r.dup).array;
//             testGrid[startX][startY] = CellVisited;

//             auto res = simulate(testGrid, startX, startY, startDirIndex);
//             if (res.loop && !res.exited) {
//                 loopCount++;
//             }

//             grid[i][j] = backup; // restore
//         }
//     }

//     writeln(loopCount);
// }