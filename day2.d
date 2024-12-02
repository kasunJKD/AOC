module day2;

import std.stdio;
import std.file;
import std.string;
import std.array;
import std.algorithm;
import std.conv;
import std.range;
import std.math; 

bool isSafe(int[] levels) {
    if (levels.length < 2) {
        return false;
    }
    int[] diffs;
    foreach (i; 0 .. levels.length - 1) {
        int diff = levels[i + 1] - levels[i];
        diffs ~= diff;
    }
    bool isIncreasing = diffs[0] > 0;
    foreach (diff; diffs) {
        int absDiff = abs(diff);
        if (absDiff < 1 || absDiff > 3) {
            return false;
        }
        if (isIncreasing && diff <= 0) {
            return false;
        }
        if (!isIncreasing && diff >= 0) {
            return false;
        }
    }
    return true;
}

void main() {
    auto result = readfile("test2_input.txt");
	auto newresult = result.map!(p => p.map!(v => to!int(v)).array).array;

	  int safecount = 0;
    foreach (levels; newresult) {
        writeln("Processing levels: ", levels);

        if (isSafe(levels)) {
            safecount++;
            writeln("Report is safe without removal.");
        } else {
            bool reportIsSafe = false;
            foreach (i; 0 .. levels.length) {
                int[] modifiedLevels = levels[0 .. i] ~ levels[(i + 1) .. $];
                writeln("Trying without level at index ", i, ": ", modifiedLevels);
                if (isSafe(modifiedLevels)) {
                    reportIsSafe = true;
                    writeln("Report becomes safe by removing level at index ", i, ".");
                    break;
                }
            }
            if (reportIsSafe) {
                safecount++;
            } else {
                writeln("Report is unsafe even after removing any single level.");
            }
        }
    }
    writeln("Number of safe reports: ", safecount);
    
}

auto readfile(string path)
{
	auto file = File(path, "r");

	auto result = file.byLine().map!(part=>part.strip.split);

	return result;
}