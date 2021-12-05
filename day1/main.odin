package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

main :: proc() {
    file, errF := os.open("input.txt")
    contents, err := os.read_entire_file(file)

    str := string(contents)
    strings := strings.split(str, "\n")
    numbers := make([]int, len(strings))

    index := 0

    for string in strings {
        number, ok := strconv.parse_int(string)
        numbers[index] = number
        index += 1
    }

    fmt.println("Part 1...")

    incCount := 0
    for i := 1; i < len(numbers); i += 1 {
        if(numbers[i - 1] < numbers[i]) {
            incCount += 1
        }
    }

    fmt.println(incCount)

    fmt.println("\nPart 2...")

    incCount = 0
    for i := 0; i < len(numbers) - 3; i += 1 {
        sumA := numbers[i] + numbers[i + 1] + numbers[i + 2];
        sumB := numbers[i + 1] + numbers[i + 2] + numbers[i + 3];

        if sumA < sumB {
            incCount += 1
        }
    }
    fmt.println(incCount)

}