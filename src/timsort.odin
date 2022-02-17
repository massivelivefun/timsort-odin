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
    for i := 0; i < len1; i += 1 {
        left[i] = it->collection[l + i]
    }
    for i := 0; i < len2; i += 1 {
        right[i] = it->collection[m + 1 + i]
    }

    i := 0
    j := 0
    k := l

    for i < len1 && j < len2 {
        if left[i] <= right[j] {
            it->collection[k] = left[i]
            i += 1
        } else {
            it->collection[k] = right[i]
            j += 1
        }
        k += 1
    }

    for i < len1 {
        it->collection[k] = left[i]
        k += 1
        j += 1
    }

    for j < len2 {
        it->collection[k] = right[j]
        k += 1
        j += 1
    }
}

timsort :: proc(it: Interface) {
    it_len = it->len()
    min_run := get_min_run(it_len)

    for i := 0; i < it_len; i += 1 {
        run_len := 0
        if i + min - 1 < it_len {
            run_len = i + min - 1
        } else {
            run_len = it_len - 1
        }
        insertion_sort(it, i, run_len)
    }

    for size := min_run; size < it_len; size = 2 * size {
        for left := 0; left < it_len; left += 2 * size {
            mid := left + size - 1
            right := 0
            if left + 2 * size - 1 < it_len - 1 {
                right = left + 2 * size - 1
            } else {
                right = it_len - 1
            }
            if mid < right {
                merge(it, left, mid, right)
            }
        }
    }
}
