module day11;

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

struct SingularArrayElement
{
	string[]* arrayElement;

	bool rule1_()
	{
		if (arrayElement !is null && (*arrayElement).length == 1 && (*arrayElement)[0] == "0")
		{
			(*arrayElement)[0] = "1";
			return true;
		}
		return false;
	}

	bool rule2_()
	{
		if (arrayElement !is null && ((*arrayElement).length) % 2 == 0)
		{
			writeln("hit");
			return true;
		}
		return false;

		//devide and create new array
	} //remove leading 0s in right

	string[][] splitArray()
	{
		size_t mid = (*arrayElement).length / 2;
		auto leftHalf = (*arrayElement)[0 .. mid];
		auto rightHalf = (*arrayElement)[mid .. $];

		if (rightHalf.all!(c => c == "0")) // Check if all elements are zeros
		{
			rightHalf = ["0"]; // Keep a single zero
		}
		// else if (leftHalf.all!(c => c == "0")) // Check for all zeros
		// {
		// 	leftHalf = ["0"]; // Keep one zero
		// }
		else
		{
			// Remove leading zeros if not all are zeros
			auto nonZeroPos = rightHalf.find!(c => c != "0");
			if (!nonZeroPos.empty)
			{
				size_t startIndex = rightHalf.length - nonZeroPos.length;
				rightHalf = rightHalf[startIndex .. $];
			}
		}

		return [leftHalf, rightHalf];
	}

	void replaceStoneWithNewValue()
	{
		if (arrayElement !is null)
		{
			try
			{
				int value = (*arrayElement).join("").to!int; // Combine and convert to int
				value *= 2024;

				(*arrayElement) = value.to!string
					.map!(c => c.to!string) // Split characters into string[]
					.array; // Replace with the new value
			}
			catch (ConvException)
			{
				writeln("Error: Invalid stone value encountered!");
			}
		}
	}
}

void main()
{
	auto file = File("test11.txt", "r");

	// Process file into a 2D array
	auto result = file.byLine()
		.map!(line => line.strip()
				.splitter(" ") // Split lines by spaces -> char[][]
				.map!(word => word.strip().splitter("")
					.map!(c => c.to!string).array).array) // Convert to string
		.array;

	// Ensure result is not empty
	if (result.empty)
	{
		writeln("File is empty.");
		return;
	}

	auto example = result[0];
	// Get the first line as a string[] directly

	int times = 25;
	for (int v = times; v > 0; v--)
	{
		auto originalExample = example.dup; // Make a copy of the current example
		example = []; // Clear the example array

		foreach (stone; originalExample)
		{
			SingularArrayElement s;
			s.arrayElement = &stone;

			bool appliedRule1 = s.rule1_();
			bool appliedRule2 = false;

			if (!appliedRule1) // Check Rule 2 if Rule 1 did not apply
			{
				appliedRule2 = s.rule2_();
				if (appliedRule2)
				{
					auto split = s.splitArray();
					example ~= split[0]; // Add left half
					if (!split[1].empty)
					{
						example ~= split[1]; // Add right half
					}
					continue;
				}
			}

			if (!appliedRule1 && !appliedRule2) // Replace stone if no rules applied
			{
				s.replaceStoneWithNewValue();
			}

			example ~= stone; // Append the updated stone
		}

		writeln("After round ", (times - v + 1), ": ", example);
		writeln("len", example.length);
	}

}
