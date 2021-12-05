package main

import "core:fmt"
import "core:strings"
import "core:strconv"

FindOnesCount :: proc(lines : []string, buffer : []int) {
    for i := 0; i < len(buffer); i += 1 {
        buffer[i] = 0
    }

    for line in lines {
        trimmed := strings.trim_space(line);
        for i := 0; i < len(buffer); i += 1 {
            buffer[i] += (trimmed[i] == '1') ? 1 : 0;
        }
    }
}

main :: proc() {
    file := string(#load("input.txt"))

    lines := strings.split(file, "\n")

    lineLen := len(strings.trim_space(lines[0]))
    linesLen := len(lines)
    onesCount := make([]int, lineLen)

    for line in lines {
        trimmed := strings.trim_space(line);
        for i := 0; i < len(onesCount); i += 1 {
            onesCount[i] += (trimmed[i] == '1') ? 1 : 0;
        }
    }

    fmt.println("Part 1...")

    gammaRates := make([]byte, len(onesCount))
    epsilonRates := make([]byte, len(onesCount))
    for i := 0; i < len(onesCount); i += 1 {
        gammaRates[i]   = (onesCount[i] > linesLen / 2) ? byte('1') : byte('0')
        epsilonRates[i] = (onesCount[i] > linesLen / 2) ? byte('0') : byte('1')
    }

    gammaStr   := strings.clone_from_bytes(gammaRates)
    epsilonStr := strings.clone_from_bytes(epsilonRates)

    gamma, _ := strconv.parse_int(gammaStr, 2)
    epsilon, _ := strconv.parse_int(epsilonStr, 2)

    fmt.println("Result: ")
    fmt.println(gamma * epsilon)

    fmt.println("Part 2...")

    count := linesLen

    for index := 0; index < lineLen; index += 1 {

        FindOnesCount(lines[:count], onesCount)
        // fmt.println(onesCount)

        mostCommon : byte = onesCount[index] * 2 >= count ? '1' : '0'

        for i := 0; i < count; i += 1 {
            if lines[i][index] != mostCommon {
                tmp := strings.clone(lines[i])

                lines[i] = lines[count - 1];
                lines[count - 1] = tmp;

                i -= 1;
                count -= 1;
            }

            if count == 1 { break }
        }

        // fmt.printf("[\n")
        // for i := 0; i < count; i += 1 {
        //     fmt.printf("%s\n", lines[i])
        // }
        // fmt.printf("]\n\n")

    }

    oxygenVal, _ := strconv.parse_int(lines[0], 2)

    count = linesLen
    for index := 0; index < lineLen; index += 1 {

        FindOnesCount(lines[:count], onesCount)
        // fmt.println(onesCount)

        mostCommon : byte = onesCount[index] * 2 >= count ? '0' : '1'

        for i := 0; i < count; i += 1 {
            if lines[i][index] != mostCommon {
                tmp := strings.clone(lines[i])

                lines[i] = lines[count - 1];
                lines[count - 1] = tmp;

                i -= 1;
                count -= 1;
            }

            if count == 1 { break }
        }

        // fmt.printf("[\n")
        // for i := 0; i < count; i += 1 {
        //     fmt.printf("%s\n", lines[i])
        // }
        // fmt.printf("]\n\n")

    }

    co2Val, _    := strconv.parse_int(lines[0], 2)

    fmt.println(oxygenVal * co2Val)
}