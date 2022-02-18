package main

import "core:fmt"
import "core:sort"
import "core:testing"

import "tim_sort"

print_array :: proc(array: []$T) {
    for i := 0; i < len(array); i += 1 {
        fmt.printf("%d  ", array[i])
    }
    fmt.println()
}

// @(test)
// test :: proc(t: ^testing.T) {
//     array := [15]int{-2, 7, 15, -14, 0, 15, 0, 7, -7, -4, -13, 5, 8, -14, 12}
//     slice := array[:]

//     print_array(slice)
//     tim_sort.tim_sort(slice)
//     print_array(slice)
//     assert(sort.is_sorted(sort.slice_interface(slice)))
// }

main :: proc() {
    array := [15]int{2, -4, -4, 3, 15, 18, 6, 7, 13, -2, 10, 10, 12, -6, 3}
    slice := array[:]
    print_array(slice)
    tim_sort.tim_sort_proc(slice, tim_sort.asc(int))
    print_array(slice)
    if sort.is_sorted(sort.slice_interface(&slice)) {
        fmt.println("it's sorted")
    } else {
        fmt.println("it's NOT sorted")
    }
}
