const std = @import("std");
const fs = std.fs;
const mem = std.mem;

const filename = "test.txt";

const line_values = struct {
    first_first: usize,
    first_second: usize,
    second_first: usize,
    second_second: usize,
};

pub fn day4() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    var total: usize = 0;
    const allocator = gpa.allocator();
    const file = try fs.cwd().openFile(filename, .{ .mode = .read_only });
    defer file.close();
    while (file.reader().readUntilDelimiterOrEofAlloc(allocator, '\n', 1024 * 1024) catch |err| {
        std.log.err("Failed to read line: {s}\n", .{@errorName(err)});
        return err;
    }) |line| {
        defer allocator.free(line);

        //----------------------------------------------------------------------
        // 1. Split line by comma: "AAA-BBB,CCC-DDD" -> ["AAA-BBB", "CCC-DDD"]
        //----------------------------------------------------------------------
        var comma_iter = mem.splitSequence(u8, line, ",");
        const maybe_first_part = comma_iter.next();
        const maybe_second_part = comma_iter.next();
        const first_part = maybe_first_part.?;
        const second_part = maybe_second_part.?;

        //----------------------------------------------------------------------
        // 2. Split each part by dash: "AAA-BBB" -> ["AAA", "BBB"]
        //----------------------------------------------------------------------
        var dash_iter1 = mem.splitSequence(u8, first_part, "-");
        var dash_iter2 = mem.splitSequence(u8, second_part, "-");

        const maybe_ff = dash_iter1.next(); // "AAA"
        const maybe_fs = dash_iter1.next(); // "BBB"
        const maybe_sf = dash_iter2.next(); // "CCC"
        const maybe_ss = dash_iter2.next(); // "DDD"

        //----------------------------------------------------------------------
        // 3. Parse each token into i32
        //----------------------------------------------------------------------
        const ff = try std.fmt.parseInt(i32, maybe_ff.?, 10);
        const fss = try std.fmt.parseInt(i32, maybe_fs.?, 10);
        const sf = try std.fmt.parseInt(i32, maybe_sf.?, 10);
        const ss = try std.fmt.parseInt(i32, maybe_ss.?, 10);

        //----------------------------------------------------------------------
        // 4. Store the parsed values in our struct
        //----------------------------------------------------------------------
        const line_value = line_values{
            .first_first = @intCast(ff),
            .first_second = @intCast(fss),
            .second_first = @intCast(sf),
            .second_second = @intCast(ss),
        };

        //----------------------------------------------------------------------
        // 5. Print or process the result
        //----------------------------------------------------------------------
        std.debug.print("Parsed line_value: {any}\n", .{line_value});
        //first solution is this ###
        // if ((ff <= sf and fss >= ss) // first range fully contains second
        //     or
        //     (sf <= ff and ss >= fss) // second range fully contains first
        // ) {
        //     total += 1;
        // }

        outter: for (line_value.first_first..line_value.first_second + 1) |v| {
            for (line_value.second_first..line_value.second_second + 1) |z| {
                if (v == z) {
                    total += 1;
                    break :outter;
                }
            }
        }
    }

    std.debug.print("Total {any}\n", .{total});
}
