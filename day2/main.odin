package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

Command :: struct {
    command : string,
    param   : int,
}

main :: proc() {
    file, _ := os.open("input.txt")
    fileContent, _ := os.read_entire_file(file)

    lines := strings.split(string(fileContent), "\n")

    commands := make([]Command, len(lines));

    for i := 0; i < len(lines); i += 1 {
        splited := strings.split(lines[i], " ")
        commands[i].command = splited[0]
        commands[i].param   = strconv.atoi(splited[1])
    }

    fmt.println("Part 1...")

    horizontal := 0
    depth      := 0

    for command in commands {
        switch command.command {
            case "forward" : horizontal += command.param
            case "up"      : depth -= command.param
            case "down"    : depth += command.param
        }
    }

    fmt.printf("Result: %d", horizontal * depth)

    ////////////////

    fmt.println("\nPart 2...")

    horizontal = 0
    depth      = 0
    aim        := 0

    for command in commands {
        switch command.command {
            case "forward": {
                horizontal += command.param
                depth += aim * command.param
            }
            case "up": {
                aim -= command.param
            }
            case "down": {
                aim += command.param
            }
        }
    }

    fmt.printf("Result: %d", horizontal * depth)
}