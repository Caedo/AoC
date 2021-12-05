package main

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:text/scanner"
import "core:math"

Point :: [2]int

PointsPair :: struct {
    a : Point,
    b : Point,
}

ParsePoint :: proc(tokenizer: ^scanner.Scanner) -> (Point, bool) {
    using scanner

    point : Point

    ch := scan(tokenizer)
    if(ch != Int) {
        return point, false
    }

    point.x, _ = strconv.parse_int(token_text(tokenizer))

    ch = scan(tokenizer) 
    if(ch != ',') {
        return point, false
    }

    ch = scan(tokenizer)
    if(ch != Int) {
        return point, false
    }

    point.y, _ = strconv.parse_int(token_text(tokenizer))

    return point, true
}

SkipArrow :: proc(tokenizer: ^scanner.Scanner) -> bool {
    using scanner

    ch := scan(tokenizer)
    if(ch != '-') {
        return false
    }

    ch = scan(tokenizer)
    if(ch != '>') {
        return false
    }

    return true
}


PrintBoard :: proc(board : []int, xMax : int, yMax : int) {
    for y: = 0; y < yMax; y += 1 {
        for x: = 0; x < xMax; x += 1 {
            fmt.print(board[y * xMax + x])
            fmt.print(" ")
        }

        fmt.print("\n")
    }
}

Part1 :: proc(pairs: [dynamic]PointsPair, xMax: int, yMax : int) {
    board := make([]int, xMax * yMax)
    defer delete(board)

    for pair, index in pairs {
        delta := pair.a - pair.b

        if delta.x != 0 && delta.y != 0 do continue

        if delta.x != 0 {
            sign := delta.x > 0 ? 1 : -1

            for x := pair.a.x; x != pair.b.x - sign; x -= sign {
                pos := Point{ x, pair.a.y }
                index := pos.y * xMax + pos.x

                board[index] += 1
            }
        }
        else if delta.y != 0 {
            sign := delta.y > 0 ? 1 : -1

            for y := pair.a.y; y != pair.b.y - sign; y -= sign {
                pos := Point{ pair.a.x, y }
                index := pos.y * xMax + pos.x

                board[index] += 1
            }
        }
        else {
            assert(false, "Delta is (0,0)")
        }

        // fmt.printf("After %d :\n", index);
        // printBoard(board, xMax, yMax)
    }

    result := 0
    for n in board {
        if(n >= 2) {
            result += 1
        }
    }

    fmt.printf("Part1 result: {}\n", result)
}

Part2 :: proc(pairs: [dynamic]PointsPair, xMax: int, yMax : int) {
    using math

    board := make([]int, xMax * yMax)
    defer delete(board)

    for pair, index in pairs {
        delta := pair.b - pair.a

        if delta.x != 0 || delta.y != 0 {
            dirX := delta.x > 0 ?  1 :
                    delta.x < 0 ? -1 : 0

            dirY := delta.y > 0 ?  1 :
                    delta.y < 0 ? -1 : 0

            dir := Point { dirX, dirY }
            pos := pair.a

            end := pair.b + {dirX, dirY}

            for pos != end {
                index := pos.y * xMax + pos.x
                board[index] += 1

                pos += dir
            }

        }
        else {
            assert(false, "Delta is (0,0)")
        }

        // fmt.printf("After %d :\n", index);
        // printBoard(board, xMax, yMax)
    }

    result := 0
    for n in board {
        if(n >= 2) {
            result += 1
        }
    }

    fmt.printf("Part2 result: {}", result)
}

main :: proc() {
    using scanner

    file := string(#load("input.txt"))
    lines := strings.split(file, "\n")

    tokenizer := init(&Scanner{}, file)

    ok : bool

    pairs := make([dynamic]PointsPair, 0, 500)

    xMax := 0
    yMax := 0

    for tokenizer.ch != EOF {
        p : PointsPair

        p.a, ok = ParsePoint(tokenizer)
        SkipArrow(tokenizer)
        p.b, ok = ParsePoint(tokenizer)

        if p.a.x > xMax do xMax = p.a.x
        if p.a.y > yMax do yMax = p.a.y
        if p.b.x > xMax do xMax = p.b.x
        if p.b.y > yMax do yMax = p.b.y

        append(&pairs, p)
    }

    fmt.printf("xMax: %d, yMax: %d\n", xMax, yMax)

    xMax += 1
    yMax += 1

    Part1(pairs, xMax, yMax)
    Part2(pairs, xMax, yMax)
}