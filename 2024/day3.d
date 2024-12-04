module day3;

import std.stdio;
import std.file;
import std.string;
import std.array;
import std.algorithm;
import std.conv;
import std.range;
import std.math; 
import std.ascii;


auto readfile(string path)
{
	auto file = File(path, "r");

    auto result = file.byLine()
                    .map!(line => line.splitter("").array)
                    .joiner
                    .array;

	return result;
}

auto peek(string[] section)
{
    string[] parttern = ["m", "u", "l", "(", "value1", ",", "value2", ")"];
    string[] newPattern = [];
    foreach (i; 0..section.length)
    {
        foreach (ii; 0..parttern.length) 
        {
            if (section[i] == parttern[ii])
            {
                //writeln("check ", parttern[ii]);
                newPattern~=section[i];
            }

            if (section[i] != parttern[ii])
            {
                if (parttern[ii] == "value1" && i > 0 && i + 1 < section.length && section[i + 1] == "," && section[i - 1] == "(") {
                    try {
                        int value = to!int(section[i]); // Attempt conversion
                        //writeln("values1 ", value);
                        newPattern~=section[i];
                    } catch (ConvException e) {
                        break;
                    }
                }
                if (parttern[ii] == "value2" && i > 0 && i + 1 < section.length && section[i - 1] == "," && section[i + 1] == ")") {
                    try {
                        int value = to!int(section[i]); // Attempt conversion
                        //writeln("values2 ", value);
                        newPattern~=section[i];
                    } catch (ConvException e) {
                        break;
                    }
                }
            } 
        }   
    }

    int total;
    foreach (i; 0..newPattern.length)
    {
        if (newPattern[i] == "m")
        {
            if (i + 4 < newPattern.length && i + 6 < newPattern.length)
            {
                try {
                    int value1 = to!int(newPattern[i + 4]);
                    int value2 = to!int(newPattern[i + 6]);
                    writeln("value1: ", value1);
                    writeln("value2: ", value2);
                    total += value1*value2;
                } catch (ConvException e) {

                }
            }
        }
    }

    return total;
    
}


void main()
{
    auto result = readfile("input.txt");
    int total = 0;


        string[] combined; 

        foreach (c; result) {
            if (!combined.empty && combined[$ - 1].all!isDigit && isDigit(c.to!string[0])) {
                combined[$ - 1] ~= c; 
            } else {
                combined ~= c.to!string; 
            }
        }

        total += peek(combined);
    

    writeln(total);
}
