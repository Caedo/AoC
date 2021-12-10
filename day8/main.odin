package main

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:text/scanner"
import "core:math"
import "core:slice"
import "core:math/bits"

Entry :: struct {
    signals : [10]string,
    output  : [4]string,
}

main :: proc() {
    using scanner

    file  := string(#load("input.txt"))

    entries := make([dynamic]Entry)

    tokenizer := init(&Scanner{}, file)
    tokenizer.whitespace -= { '\n' }

    idx := 0

    sigIdx := 0
    outIdx := 0

    append_nothing(&entries)

    for tokenizer.ch != EOF {
        current := &entries[idx]

        ch := scan(tokenizer)

        if ch == '\n' {
            append_nothing(&entries)

            idx += 1

            sigIdx = 0
            outIdx = 0
        }
        else if(ch == '|') {
            // nothing
        }
        else {

            if(sigIdx < 10) {
                current.signals[sigIdx] = strings.clone(token_text(tokenizer))
                sigIdx += 1
            }
            else {
                current.output[outIdx] = strings.clone(token_text(tokenizer))
                outIdx += 1
            }
        }
    }

    res := 0
    for entry in entries {
        for o in entry.output {

            if len(o) == 2 ||
               len(o) == 3 ||
               len(o) == 4 ||
               len(o) == 7
               {
                    res += 1
               }
        }
    }

    fmt.println(res);

    // Part 2 

    sum := 0

    for entry in entries {
        signals    : [10]string

        lengthsMap : map[int][dynamic]string

        lengthsMap[2] = make([dynamic]string)
        lengthsMap[3] = make([dynamic]string)
        lengthsMap[4] = make([dynamic]string)
        lengthsMap[5] = make([dynamic]string)
        lengthsMap[6] = make([dynamic]string)
        lengthsMap[7] = make([dynamic]string)

        for sig in entry.signals {
            append(&lengthsMap[len(sig)], sig)

            if(len(sig) == 2) {
                signals[1] = sig
            }
            if(len(sig) == 3) {
                signals[7] = sig
            }
            if(len(sig) == 4) {
                signals[4] = sig
            }
            if(len(sig) == 7) {
                signals[8] = sig
            }
        }

        // find 6
        for sig in lengthsMap[6] {
            if(CommonSegments(sig, signals[7]) == 2) {
                signals[6] = sig
                break
            }
        }

        // find 9
        for sig in lengthsMap[6] {
            if(CommonSegments(sig, signals[4]) == 4) {
                signals[9] = sig
                break
            }
        }

        // the other one is 0
        for sig in lengthsMap[6] {
            if slice.contains(signals[:], sig) == false {
                signals[0] = sig
                break;
            }
        }

        // find 5 
        for sig in lengthsMap[5] {
            if(CommonSegments(sig, signals[6]) == 5) {
                signals[5] = sig
                break
            }
        }

        // find 2
        for sig in lengthsMap[5] {
            if(CommonSegments(sig, signals[4]) == 2) {
                signals[2] = sig
                break
            }
        }

        // the other one is 3
        for sig in lengthsMap[5] {
            if slice.contains(signals[:], sig) == false {
                signals[3] = sig
                break;
            }
        }

        result := 0
        mult := 1000
        for out in entry.output {

            for sig, sigIdx in signals {
                if AreEqual(out, sig) {
                    result += sigIdx * mult

                    mult /= 10
                    break
                }
            }
        }


        // fmt.println(lengthsMap)

        sum += result
        
        fmt.println(signals)
        fmt.printf("out: {} Result: {}\n", entry.output, result)
        fmt.println()

    }

    fmt.printf("Sum: {}", sum)

    CommonSegments :: proc(a : string, b : string) -> (count : int) {
        longer  : string
        shorter : string

        if len(a) > len(b) {
            longer = a
            shorter = b
        }
        else {
            longer = b
            shorter = a
        }


        for r in longer {
            if strings.contains_rune(shorter, r) != -1 {
                count += 1
            }
        }

        return
    }

    AreEqual :: proc(a : string, b : string) -> bool {
        if len(a) != len(b) {
            return false
        }

        return CommonSegments(a, b) == len(a)
    }

}