package main

import "core:fmt"
import "core:strings"
import "core:strconv"

Board :: struct {
    data : [25]int,
    marked : [25]bool,

    solved : bool,
}

IsBoardCompleted :: proc(board: ^Board) -> bool {
    // rows
    for i := 0; i < 5; i += 1 {
        if board.marked[i * 5 + 0] && 
           board.marked[i * 5 + 1] && 
           board.marked[i * 5 + 2] && 
           board.marked[i * 5 + 3] && 
           board.marked[i * 5 + 4]
        {
            return true
        }
    }

    // columns
    for i := 0; i < 5; i += 1 {
        if board.marked[0  + i] && 
           board.marked[5  + i] && 
           board.marked[10 + i] && 
           board.marked[15 + i] && 
           board.marked[20 + i]
        {
            return true
        }
    }

    return false
}

CalculateScore :: proc(board: ^Board) -> int {
    score := 0

    for _, index in board.data {
        if board.marked[index] == false {
            score += board.data[index]
        }
    }

    return score
}

main :: proc() {

    file := string(#load("input.txt"))
    lines := strings.split(file, "\n")

    numbersStr := strings.split(lines[0], ",")
    numbers := make([]int, len(numbersStr))

    ok := false
    for number, index in numbersStr {
        numbers[index], ok = strconv.parse_int(strings.trim(numbersStr[index], " \t\r\n"))
        assert(ok)
    }

    boards : [dynamic]Board;

    // fist and second lines are drawn numbers and empty line
    rowsCounter := 0;
    current : ^Board

    for i := 2; i < len(lines); i += 1 {
        trimmed := strings.trim(lines[i], " \t\r\n")

        if len(trimmed) == 0 do continue

        if(rowsCounter == 0) {
            append_nothing(&boards)
            current = &boards[len(boards) - 1]
        }

        fields := strings.fields(trimmed)
        for rowI := 0; rowI < 5; rowI += 1 {
            index := rowsCounter * 5 + rowI

            number, ok := strconv.parse_int(fields[rowI])
            current.data[index] = number

            assert(ok)
        }

        rowsCounter = (rowsCounter + 1) % 5
    }

    firstWinningScore := -1
    lastWinnigScore := -1

    winningCount := 0

    outer: for number in numbers {

        for board, boardIndex in &boards {
            if board.solved == true do continue

            for dat, index in board.data {
                if dat == number {
                    boards[boardIndex].marked[index] = true

                    if IsBoardCompleted(&boards[boardIndex]) {
                        board.solved = true

                        if firstWinningScore == -1 {
                            firstWinningScore = CalculateScore(&boards[boardIndex]) * number
                        }

                        lastWinnigScore = CalculateScore(&boards[boardIndex]) * number
                        fmt.printf("Winning number: %d, board score: %d\n", number, CalculateScore(&boards[boardIndex]))
                        winningCount += 1

                        if(winningCount == len(boards)) do break outer
                    }
                }
            }
        }
    }

    fmt.printf("First winning score: %d\n", firstWinningScore)
    fmt.printf("Last winning score:  %d\n", lastWinnigScore)
}