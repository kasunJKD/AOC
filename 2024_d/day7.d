module day7;

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

bool canMatch(long target, long[] numbers) {
    import std.variant;
    
    bool evaluate(long index, long current, long[] numbers) {
        if (index == numbers.length) {
            return current == target;
        }
        
        // Apply '+' operator
        if (evaluate(index + 1, current + numbers[index], numbers)) {
            return true;
        }
        
        // Apply '*' operator
        if (evaluate(index + 1, current * numbers[index], numbers)) {
            return true;
        }

        long concatenated = to!long(to!string(current) ~ to!string(numbers[index]));
        if (evaluate(index + 1, concatenated, numbers)) {
            return true;
        }
        
        return false;
    }
    
    return evaluate(1, numbers[0], numbers);
}

void main()
{
    auto file = File("test7.txt", "r");

    auto result = file.byLine().map!(line => line.strip()).map!(c => c.idup).array;

    long total = 0;

    foreach (value; result)
    {
        auto splitValue = value.splitter(":").array;
        long left = to!long(splitValue[0]);
        long[] right = strip(splitValue[1]).splitter(" ").map!(c => to!long(c.idup)).array;
        

        if (canMatch(left, right)) {
            total += left;
        }
    }

    writeln(total);


}