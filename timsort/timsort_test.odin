package timsort

import "core:fmt"
import "core:sort"
import "core:testing"

print_slice :: proc(slice: []int) {
    for i in slice {
        fmt.printf("%d  ", i)
    }
    fmt.println()
}

// Currently the Odin compiler's test command is broken (Feb 21 2022). Check in
// later when the test command works and check if this test is valid.
@(test)
simple_and_small_sort_check :: proc(t: ^testing.T) {
    array := [15]int{-2, 7, 15, -14, 0, 15, 0, 7, -7, -4, -13, 5, 8, -14, 12}
    slice := array[:]

    timsort(slice)
    if !sort.is_sorted(sort.slice_interface(&slice)) {
        t.error("This array is NOT sorted correctly.")
        print_slice(slice)
    }
}

@(test)
simple_with_custom_proc_call :: proc(t: ^testing.T) {
    array := [15]int{-2, 7, 15, -14, 0, 15, 0, 7, -7, -4, -13, 5, 8, -14, 12}
    slice := array[:]

    timsort_proc(slice, asc(int))
    if !sort.is_sorted(sort.slice_interface(&slice)) {
        t.error("This array is NOT sorted correctly.")
        print_slice(slice)
    }
}
