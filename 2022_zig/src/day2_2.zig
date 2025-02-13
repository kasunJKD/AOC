const std = @import("std");
const fs = std.fs;
const print = std.debug.print;

const filename = "test.txt";

const bot_score = enum(i64) {
    A = 1, // Rock
    B = 2, // Paper
    C = 3, // Scissors
};

const player_score = enum(i64) {
    X = 0, // Lose
    Y = 3, // Draw
    Z = 6, // Win
};

fn parseBot(c: u8) !bot_score {
    return switch (c) {
        'A' => bot_score.A,
        'B' => bot_score.B,
        'C' => bot_score.C,
        else => return error.InvalidBotLetter,
    };
}

fn parsePlayer(c: u8) !player_score {
    return switch (c) {
        'X' => player_score.X,
        'Y' => player_score.Y,
        'Z' => player_score.Z,
        else => return error.InvalidPlayerLetter,
    };
}

/// Determine the player's move based on the bot's move and the desired outcome.
fn determinePlayerMove(bot_move: bot_score, desired_outcome: player_score) !bot_score {
    return switch (desired_outcome) {
        .X => switch (bot_move) { // Lose
            .A => bot_score.C, // Bot chooses Rock, player chooses Scissors
            .B => bot_score.A, // Bot chooses Paper, player chooses Rock
            .C => bot_score.B, // Bot chooses Scissors, player chooses Paper
        },
        .Y => bot_move, // Draw: player chooses the same as the bot
        .Z => switch (bot_move) { // Win
            .A => bot_score.B, // Bot chooses Rock, player chooses Paper
            .B => bot_score.C, // Bot chooses Paper, player chooses Scissors
            .C => bot_score.A, // Bot chooses Scissors, player chooses Rock
        },
    };
}

/// Calculate the score for a round.
fn calculateScore(bot_move: bot_score, player_move: bot_score) i64 {
    const shape_score = @intFromEnum(player_move);
    const bot_value = @intFromEnum(bot_move);
    const player_value = @intFromEnum(player_move);

    var outcome_score: i64 = 0;
    if (bot_value == player_value) {
        outcome_score += 3;
    } // Draw
    else if ((bot_value == 1 and player_value == 3) or
        (bot_value == 3 and player_value == 2) or
        (bot_value == 2 and player_value == 1))
    {
        outcome_score += 0;
    } // Lose
    else {
        outcome_score += 6;
    } // Win

    return shape_score + outcome_score;
}

pub fn day2_2() !void {
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
        const desired_outcome = try parsePlayer(line[2]);
        const player_move = try determinePlayerMove(bot_move, desired_outcome);

        const value = calculateScore(bot_move, player_move);
        total += value;

        print("Bot: {any}, Player: {any}, Outcome: {any}, Score: {any}\n", .{
            bot_move, player_move, desired_outcome, value,
        });
    }

    print("Total Score: {any}\n", .{total});
}
