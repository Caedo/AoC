package main

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:text/scanner"
import "core:math"


main :: proc() {
    file := string(#load("input.txt"))
    valuesStr := strings.split(file, ",")

    fishesCount : [9]int
    second      : [9]int

    for str in valuesStr {
        value, ok := strconv.parse_int(str)
        fishesCount[value] += 1
    }

    // cycles :: 80 // - part 1
    cycles :: 256

    for _ in 0..<cycles {
        
        tmp := fishesCount[0]
        for i:= 0; i < 9; i += 1 {
            previous := (i - 1) < 0 ? 8 : (i - 1)
            second[previous] = fishesCount[i]
        }

        second[6] += tmp

        for v, i in second {
            fishesCount[i] = v
        }
    }

    sum : int = math.sum(fishesCount[:])
    fmt.printf("Sum: {}", sum)
}