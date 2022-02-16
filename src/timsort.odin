package main

import "core:fmt"
import "core:intrinsics"

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
