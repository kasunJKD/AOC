const std = @import("std");
const fs = std.fs;
const print = std.debug.print;

const filename = "test.txt";

const bot_score = enum(i64) {
    A = 1,
    B = 2,
    C = 3,
};

const player_score = enum(i64) {
    X = 1,
    Y = 2,
    Z = 3,
};

fn parseBot(c: u8) !bot_score {
    return switch (c) {
        'A' => bot_score.A,
        'B' => bot_score.B,
        'C' => bot_score.C,
        else => return error.InvalidBotLetter,
    };
}

/// Parse a single character into a player_score enum.
fn parsePlayer(c: u8) !player_score {
    return switch (c) {
        'X' => player_score.X,
        'Y' => player_score.Y,
        'Z' => player_score.Z,
        else => return error.InvalidPlayerLetter,
    };
}

const game_score = enum(i64) {
    WIN = 6,
    DRAW = 3,
    LOSE = 0,
};

fn game_rules_score(valueA: i64, valueB: i64) !i64 {
    var final_score: i64 = 0;

    final_score += valueB;

    if (valueA == valueB) {
        final_score += @intFromEnum(game_score.DRAW);
    } else if ((valueA == 1 and valueB == 3) or 
               (valueA == 3 and valueB == 2) or 
               (valueA == 2 and valueB == 1)) {
        final_score += @intFromEnum(game_score.LOSE);
    } else {
        final_score += @intFromEnum(game_score.WIN);
    }

    return final_score;
}

pub fn day2() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const file = try fs.cwd().openFile(filename, .{ .mode = .read_only });
    defer file.close();
    var total: i64 = 0;
    while (file.reader().readUntilDelimiterOrEofAlloc(allocator, '\n', 1024 * 1024) catch |err| {
        std.log.err("Failed to read line: {s}\n", .{@errorName(err)});
        return err;
    }) |line| {
        defer allocator.free(line);
        const bot_move = try parseBot(line[0]);
        const player_move = try parsePlayer(line[2]);
        const value = try game_rules_score(@intFromEnum(bot_move), @intFromEnum(player_move));
        total += value;

        print("Line: {any}\n", .{@intFromEnum(try parseBot(line[0]))});
    }

    print("Line: {any}\n", .{total});
}
