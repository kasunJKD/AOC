const std = @import("std");
const fs = std.fs;
const print = std.debug.print;

const filename = "test.txt";

pub fn day1() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const file = try fs.cwd().openFile(filename, .{ .mode = .read_only });
    defer file.close();

    var total: i32 = 0;
    var totalcurr: i32 = 0;
    while (file.reader().readUntilDelimiterOrEofAlloc(allocator, '\n', 1024 * 1024) catch |err| {
        std.log.err("Failed to read line: {s}\n", .{@errorName(err)});
        return err; // Return the error instead of silently exiting
    }) |line| {
        defer allocator.free(line);

        if (line.len == 0) {
            if (totalcurr > total) {
                total = totalcurr;
            }
            totalcurr = 0;
        } else {
            const value = try std.fmt.parseInt(i32, line, 10);
            totalcurr += value;
        }

        print("Line: {s}\n", .{line}); // Corrected format specifier
    }

    print("total {any}\n", .{total});
}

pub fn day1_2() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const file = try fs.cwd().openFile(filename, .{ .mode = .read_only });
    defer file.close();

    var totalcurr: i32 = 0;
    var list = std.ArrayList(i32).init(allocator);
    defer list.deinit();
    while (file.reader().readUntilDelimiterOrEofAlloc(allocator, '\n', 1024 * 1024) catch |err| {
        std.log.err("Failed to read line: {s}\n", .{@errorName(err)});
        return err; // Return the error instead of silently exiting
    }) |line| {
        defer allocator.free(line);

        if (line.len == 0) {
            try list.append(totalcurr);
            totalcurr = 0;
        } else {
            const value = try std.fmt.parseInt(i32, line, 10);
            totalcurr += value;
        }

        print("Line: {s}\n", .{line}); // Corrected format specifier
    }
    std.mem.sort(i32, list.items, {}, std.sort.desc(i32));
    print("Sorted List: {any}\n", .{list.items});

    var total: i32 = 0;

    for (list.items[0..3]) |value| {
        total += value;
    }
    print("{any}\n", .{total});
}
