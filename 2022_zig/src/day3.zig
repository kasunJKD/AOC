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

fn common_value(first: []const u8, second: []const u8, third: []const u8) ?u8 {
    for (first) |x| {
        for (second) |y| {
            for (third) |z| {
                if (x == y and y == z) {
                    return x;
                }
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

// pub fn day3_2() !void {
//     var gpa = std.heap.GeneralPurposeAllocator(.{}){};
//     defer _ = gpa.deinit();
//     const allocator = gpa.allocator();
//     const file = try fs.cwd().openFile(filename, .{ .mode = .read_only });
//     defer file.close();
//     var arrayv = std.ArrayList([]u8).init(allocator);
//     defer arrayv.deinit();
//     while (try file.reader().readUntilDelimiterOrEofAlloc(allocator, '\n', 1024 * 1024)) |line| {
//         defer allocator.free(line);
//         try arrayv.append(line);
//         print("Line: {s}\n", .{line});
//     }
//     for (arrayv.items) |item| {
//         std.debug.print("{s}\n", .{item});
//     }
// }

pub fn day3_2() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var total: i32 = 0;

    const file = try fs.cwd().openFile(filename, .{ .mode = .read_only });
    defer file.close();

    var arrayv = std.ArrayList([]u8).init(allocator);
    defer {
        // Free each line in the list before deinitializing the list
        for (arrayv.items) |item| {
            allocator.free(item);
        }
        arrayv.deinit();
    }

    // Read lines from the file and store them in the list
    while (try file.reader().readUntilDelimiterOrEofAlloc(allocator, '\n', 1024 * 1024)) |line| {
        try arrayv.append(line);
    }

    // Print all lines from the list
    var i: usize = 0;
    while (i + 2 < arrayv.items.len) {
        std.debug.print("Line: {d}\n", .{i});
        const common_va = common_value(arrayv.items[i], arrayv.items[i + 1], arrayv.items[i + 2]);
        if (common_va) |found| {
            if (getPriority(found)) |priority| {
                std.debug.print("exists: {d}\n", .{priority});
                total += priority;
            }
        }
        std.debug.print("{s}\n", .{arrayv.items[i]});
        std.debug.print("{d}\n", .{total});
        i += 3;
    }
}
