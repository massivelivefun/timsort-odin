package main

import "core:fmt"
import "core:intrinsics"
import "core:sort"

main :: proc() {
    fmt.println("hello")
    fmt.println(get_min_run(128))
}

get_min_run :: proc(n: int) -> int {
    r := 0
    n2 := n
    for n2 >= 64 {
        r |= n2 & 1
        n2 >>= 1
    }
    return n2 + r
}

insertion_sort :: proc(it: Interface, a, b: int) {
    for i in a+1..<b {
        for j := i; j > a && it->less(j, j-1); j -= 1 {
            it->swap(j, j-1)
        }
    }
}
