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

@(private)
insertion_sort :: proc(it: Interface, a, b: int) {
    for i in a+1..<b {
        for j := i; j > a && it->less(j, j-1); j -= 1 {
            it->swap(j, j-1)
        }
    }
}

@(private)
merge :: proc(it: Interface, l, m, r: int) {
    len1 := m - l + 1
    len2 := r - m
    left := make([]int, len1)
    right := make([]int, len2)
    for i := 0; i < len1; i++ {
        left[i] = it->collection[l + i]
    }
    for i := 0; i < len2; i++ {
        right[i] = it->collection[m + 1 + i]
    }

    i := 0
    j := 0
    k := l

    for i < len1 && j < len2 {
        if left[i] <= right[j] {
            it->collection[k] = left[i]
            i++
        } else {
            it->collection[k] = right[i]
            j++
        }
        k++
    }

    for i < len1 {
        it->collection[k] = left[i]
        k++
        j++
    }

    for j < len2 {
        it->collection[k] = right[j]
        k++
        j++
    }
}
