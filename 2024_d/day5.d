module day5;

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


// void main()
// {
//     // Read and parse the input file
//     auto result = readfile("test5.txt");

//     int[][int] mapper; // Map from page number X to a list of pages that must come after X
//     int[][] lines;     // List of updates (each update is an array of pages)

//     // The input format: Lines with "X|Y" are rules, lines with commas and no '|' are updates.
//     // result is read line by line, each line split by '|'.
//     foreach (section; result)
//     {
//         if (section.length == 0) {
//             continue; // skip empty lines if any
//         }

//         // If section.length == 2, we have a rule: X|Y
//         if (section.length == 2) {
//             int key = to!int(section[0].strip);
//             int value = to!int(section[1].strip);

//             mapper[key] ~= value; 
//         }
//         // If section.length == 1, we have an update line (pages separated by commas)
//         else if (section.length == 1) {
//             int[] values = section[0].splitter(",").map!(v => to!int(v.strip)).array;
//             lines ~= [values];
//         }
//     }

//     int total = 0;

//     // Check each update
//     foreach (update; lines)
//     {
//         bool valid = true;

//         // For each rule X -> [Y1, Y2, ...]
//         foreach (x; mapper.keys)
//         {
//             foreach (y; mapper[x])
//             {
//                 // Check if both X and Y are in the update
//                 auto iX = update.countUntil(x);
//                 auto iY = update.countUntil(y);

//                 // If both pages are found in this update, verify order
//                 if (iX < update.length && iY < update.length)
//                 {
//                     // X must come before Y
//                     if (iX >= iY)
//                     {
//                         valid = false;
//                         break;
//                     }
//                 }
//             }
//             if (!valid) break;
//         }

//         if (valid)
//         {
//             // Add the middle page number to total
//             total += update[update.length / 2];
//         }
//     }

//     writeln(total);
// }

// auto readfile(string path)
// {
//     // Read and parse the input file line by line,
//     // splitting each line by '|'.
//     auto file = File(path, "r");
//     auto result = file.byLine()
//                       .map!(line => line.strip().splitter("|").map!(c => c.idup).array)
//                       .array;

//     return result;
// }

int[] topologicalSort(int[] nodes, int[][int] adj) {
    // Calculate in-degrees
    int[int] inDegree;
    foreach(n; nodes) inDegree[n] = 0;

    foreach(x, neighbors; adj) {
        foreach(y; neighbors) inDegree[y]++;
    }

    int[] queue;
    foreach(n; nodes) {
        if (inDegree[n] == 0) queue ~= n;
    }

    int[] result;
    while (!queue.empty) {
        int current = queue[0];
        queue = queue[1 .. $]; // remove front

        result ~= current;

        foreach(next; adj[current]) {
            inDegree[next]--;
            if (inDegree[next] == 0)
                queue ~= next;
        }
    }

    return result; // Assuming no cycles
}

void main() {
    auto lines = readfile("test5.txt");

    int[][int] mapper; // rules
    int[][] updates;

    foreach (parts; lines) {
        if (parts.length == 0) continue;

        if (parts.length == 2) {
            int X = to!int(parts[0].strip);
            int Y = to!int(parts[1].strip);
            mapper[X] ~= Y;
        } else if (parts.length == 1) {
            int[] update = parts[0].splitter(",").map!(s => to!int(s.strip)).array;
            updates ~= update;
        }
    }

    int correctlyOrderedTotal = 0;
    int incorrectlyOrderedTotal = 0;

    foreach (update; updates) {
        bool isCorrect = true;
        foreach (x, successors; mapper) {
            foreach(y; successors) {
                // countUntil returns a long, cast to int
                int iX = cast(int)update.countUntil(x);
                int iY = cast(int)update.countUntil(y);
                if (iX < update.length && iY < update.length && iX >= iY) {
                    isCorrect = false;
                    break;
                }
            }
            if (!isCorrect) break;
        }

        if (isCorrect) {
            correctlyOrderedTotal += update[update.length / 2];
        } else {
            // Re-order using topological sort
            auto pages = update.dup;
            pages.sort(); // now pages is a sorted array of ints

            int[][int] adj;
            foreach(p; pages) adj[p] = [];

            foreach (x, successors; mapper) {
                foreach(y; successors) {
                    int iX = cast(int)pages.countUntil(x);
                    int iY = cast(int)pages.countUntil(y);
                    if (iX < pages.length && iY < pages.length) {
                        adj[x] ~= y;
                    }
                }
            }

            auto sortedUpdate = topologicalSort(pages, adj);
            incorrectlyOrderedTotal += sortedUpdate[sortedUpdate.length / 2];
        }
    }

    writeln("Sum of middle pages (correct updates): ", correctlyOrderedTotal);
    writeln("Sum of middle pages (re-ordered incorrect updates): ", incorrectlyOrderedTotal);
}

auto readfile(string path) {
    auto file = File(path, "r");
    return file.byLine()
               .map!(line => line.strip().splitter("|").map!(c => c.idup).array)
               .array;
}