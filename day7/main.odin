package main

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:text/scanner"
import "core:math"
import "core:slice"
import "core:math/bits"

costCache := make(map[int]int)

main :: proc() {
    file := string(#load("input.txt"))
    
    valuesStr := strings.split(file, ",")
    positions := make([]int, len(valuesStr))


    ok := false
    for str, i in valuesStr {
        positions[i], ok = strconv.parse_int(str)
    }


    min := slice.min(positions)
    max := slice.max(positions)

    minFuel := 1 << 31 - 1
    minPos  := -1

    for target in min..max {
        fuel := 0
        for pos in positions {
            fuel += abs(pos - target)
        }

        if(fuel < minFuel) {
            minFuel = fuel
            minPos = target
        }
    }

    fmt.printf("Part1: MinFuel: {}, Target: {}\n", minFuel, minPos)

    // Part2, I'm really tired today so here is brute force!

    Cost :: proc(delta: int) -> int {

        if delta in costCache {
            return costCache[delta]
        }

        sum := 0
        for i in 1..delta {
            sum += i
        }

        costCache[delta] = sum
        return sum
    }

    minFuel = 1 << 31 - 1
    minPos  = -1

    for target in min..max {
        fuel := 0
        for pos in positions {
            fuel += Cost(abs(pos - target))
        }

        if(fuel < minFuel) {
            minFuel = fuel
            minPos = target
        }
    }

    fmt.printf("Part2: MinFuel: {}, Target: {}", minFuel, minPos)

}