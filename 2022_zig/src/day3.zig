const std = @import("std");
const fs = std.fs;
const print = std.debug.print;

const filename = "test.txt";

fn compare(first: []const u8, second: []const u8) ?u8 {
    for (first) |x| {
        for (second) |y| {
            if (x == y) {
                return x;
            }
        }
    }

    return null;
}

fn getPriority(letter: u8) ?u8 {
    return switch (letter) {
        'a'...'z' => letter - 'a' + 1,
        'A'...'Z' => letter - 'A' + 27,
        else => null,
    };
}

pub fn day3() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    var total: i32 = 0;
    const file = try fs.cwd().openFile(filename, .{ .mode = .read_only });
    defer file.close();
    while (file.reader().readUntilDelimiterOrEofAlloc(allocator, '\n', 1024 * 1024) catch |err| {
        std.log.err("Failed to read line: {s}\n", .{@errorName(err)});
        return err;
    }) |line| {
        defer allocator.free(line);

        const firstHalf = line[0..(line.len / 2)];
        const secondHalf = line[(line.len / 2)..(line.len)];

        const compare_exists = compare(firstHalf, secondHalf);

        if (compare_exists) |found| {
            if (getPriority(found)) |priority| {
                std.debug.print("exists: {d}\n", .{priority});
                total += priority;
            }
        }

        print("Line: {any}\n", .{total});
    }
}
