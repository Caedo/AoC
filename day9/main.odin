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

Point :: [2]int

mapWidth  : int
mapHeight : int

Get :: proc(m : []int, p : Point) -> int {
    idx := p.y * mapWidth + p.x
    return m[idx]
}

IsInsideMap :: proc(p: Point) -> bool {
    return p.x >= 0 && p.x < mapWidth && p.y >= 0 && p.y < mapHeight
}

Neighbours :: proc(m : []int, p: Point, buffer: []int) -> int {
    idx := 0
    dirs : []Point = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}}

    for dir in dirs {
        if IsInsideMap(p + dir) {
            buffer[idx] = Get(m, p + dir)
            idx += 1
        }
    }

    return idx
}

Neighbours2 :: proc(m : []int, p: Point, buffer: []Point) -> int {
    idx := 0
    dirs : []Point = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}}

    for dir in dirs {
        if IsInsideMap(p + dir) {
            buffer[idx] = p + dir
            idx += 1
        }
    }

    return idx
}

FloodFill :: proc(m: []int, p: Point) -> (size: int) {
    neighbours : [4]Point

    // Build in queue is currently broken so here is weird implementation on very large buffer
    queue := make([dynamic]Point, mapWidth * mapHeight)
    defer delete(queue)

    queue[0] = p
    qLen := 1

    visited := make([dynamic]Point)
    defer delete(visited)

    append(&visited, p)

    for qLen != 0 {
        current := queue[qLen - 1]
        qLen -= 1

        currentValue := Get(m, current)
        count := Neighbours2(m, current, neighbours[:])

        for i in 0..<count {
            v := Get(m, neighbours[i])

            if v > currentValue && v < 9 && slice.contains(visited[:], neighbours[i]) == false {
                queue[qLen] = neighbours[i]
                qLen += 1

                append(&visited, neighbours[i])

                fmt.println(v)
            }
        }
    }
    fmt.println()

    return len(visited)
}


main :: proc() {
    using scanner

    file  := string(#load("input.txt"))
    lines := strings.split(file, "\n")

    mapWidth  = len(strings.trim(lines[0], "\n\t\r"))
    mapHeight = len(lines)

    hMap := make([]int, mapWidth * mapHeight)

    for line, y in lines {
        l := strings.trim(line, "\n\t\r")
        for r, x in l {
            idx := y * mapWidth + x

            s, i := utf8.encode_rune(r)
            hMap[idx] = int(s[0] - '0')
        }
    }

    // for y in 0..<mapHeight {
    //     for x in 0..<mapWidth {
    //         v := Get(hMap, {x, y})
    //         fmt.print(v)
    //     }

    //     fmt.println()
    // }

    part1 := 0
    neighbours : [4]int

    basinsSize := make([dynamic]int)

    for h, i in hMap {
        x := i % mapWidth
        y := i / mapWidth

        count := Neighbours(hMap, {x, y}, neighbours[:])

        isLowest := true
        for nIdx in 0..<count {
            if neighbours[nIdx] <= h {
                isLowest = false
                break
            }
        }

        if isLowest {
            part1 += h + 1

            flood := FloodFill(hMap, {x, y})
            fmt.println("size: ", flood, "point:", Point{x, y})

            append(&basinsSize, flood)

        }
    }

    slice.reverse_sort(basinsSize[:])
    fmt.println(basinsSize)

    part2 := basinsSize[0] * basinsSize[1] * basinsSize[2]

    fmt.println("part1: ", part1)
    fmt.println("part2: ", part2)
}