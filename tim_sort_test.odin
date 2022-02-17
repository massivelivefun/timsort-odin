package main

import "core:fmt"
import "core:sort"

import "tim_sort"

print_array :: proc(array: []$T) {
    for i := 0; i < len(array); i += 1 {
        fmt.printf("%d  ", array[i])
    }
    fmt.println()
}

main :: proc() {
    array := [15]int{2, -4, -4, 3, 15, 18, 6, 7, 13, -2, 10, 10, 12, -6, 3}
    slice := array[:]
    print_array(slice)
    tim_sort.tim_sort_proc(slice, tim_sort.asc(int))
    print_array(slice)
}
