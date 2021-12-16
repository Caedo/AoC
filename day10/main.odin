package main

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:text/scanner"
import "core:math"
import "core:slice"
import "core:unicode/utf8"
import "core:math/bits"
import "core:container"
import "core:intrinsics"


main :: proc() {
    using scanner

    file  := string(#load("input.txt"))
    lines := strings.split(file, "\n")

    open  : []rune = {'(', '{', '[', '<'}
    close : []rune = {')', '}', ']', '>'}
    scores : []int = {3, 1197, 57, 25137 }

    stack : [100]rune
    stackTop := -1

    incomplete : [dynamic]string

    index_of :: proc(array : $T/[]$E, elem: E) -> int where intrinsics.type_is_comparable(E) {
        for e, i in array {
            if e == elem {
                return i
            }
        }

        return -1
    }

    // part1
    errorScore := 0
    for line in lines {
        defer stackTop = -1

        trimmed := strings.trim(line, "\n\t\r")

        corrupted := false
        for r in trimmed {
            if slice.contains(open, r) {
                stack[stackTop + 1] = r
                stackTop += 1
            }
            else {
                index := index_of(close, r)

                if stack[stackTop] != open[index] {
                    errorScore += scores[index]
                    
                    corrupted = true
                    break
                }
                else {
                    stackTop -= 1
                }
            }
        }

        if corrupted == false {
            append(&incomplete, trimmed)
        }
    }

    fmt.println("Part1: ", errorScore)

    // part 2

    scores2 : []int = {1, 3, 2, 4}

    lineScores := make([]int, len(incomplete))

    for line, lineIdx in incomplete {
        score := 0

        for r in line {
            if slice.contains(open, r) {
                stack[stackTop + 1] = r
                stackTop += 1
            }
            else {
                stackTop -= 1
            }
        }

        for i := stackTop; i >= 0; i -= 1 {
            index := index_of(open, stack[i])
            score *= 5
            score += scores2[index]
        }

        lineScores[lineIdx] = score
        stackTop = -1
    }

    slice.sort(lineScores)
    fmt.println(lineScores)
    fmt.println("Part 2", lineScores[len(lineScores) / 2])

}