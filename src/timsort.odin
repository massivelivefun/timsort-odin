package main

import "core:fmt"
import "core:intrinsics"
import "core:sort"

Interface :: sort.Interface
slice_interface :: sort.slice_interface

main :: proc() {
    array := [15]int{-2, 7, 15, -14, 0, 15, 0, 7, -7, -4, -13, 5, 8, -14, 12}
    slice := array[:]

    print_array(slice)
    timsort(slice)
    print_array(slice)
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

print_array :: proc(array: $A/[]$T) {
    for i := 0; i < len(array); i += 1 {
        fmt.printf("%d  ", array[i])
    }
    fmt.println()
}

timsort :: proc(array: $A/[]$T) where intrinsics.type_is_ordered(T) {
    merge :: proc(a: A, start, mid, end: int) {
        s, m := start, end

        s2 := m + 1
        if a[m] <= a[s2] {
            return
        }

        for s <= m && s2 <= end {
            if a[s] <= a[s2] {
                s += 1
            } else {
                v := a[s2]
                i := s2

                for i != s {
                    a[i] = a[i-1]
                    i -= 1
                }
                a[s] = v

                s += 1
                m += 1
                s2 += 1
            }
        }
    }
    insertion_sort :: proc(a: A, start, end: int) {
        for i in start+1..<end {
            for j := i; j > start && a[j] < a[j-1]; j -= 1 {
                a[j], a[j-1] = a[j-1], a[j]
            }
        }
    }

    n := len(array)
    min_run := get_min_run(n)

    for i := 0; i < n; i += min_run {
        run_len := 0
        if (i + min_run - 1) < (n - 1) {
            run_len = i + min_run - 1
        } else {
            run_len = n - 1
        }
        insertion_sort(array, i, run_len)
    }

    for size := min_run; size < n; size = 2 * size {
        for left := 0; left < n; left += 2 * size {
            mid := left + size - 1
            right := 0
            if (left + 2 * size - 1) < (n - 1) {
                right = left + 2 * size - 1
            } else {
                right = n - 1
            }
            if mid < right {
                merge(array, left, mid, right)
            }
        }
    }
}

// @(private)
// insertion_sort_interface :: proc(it: Interface, a, b: int) {
//     for i in a+1..<b {
//         for j := i; j > a && it->less(j, j-1); j -= 1 {
//             it->swap(j, j-1)
//         }
//     }
// }

// @(private)
// merge_interface :: proc(it: Interface, l, m, r: int) {
//     len1 := m - l + 1
//     len2 := r - m
//     left := make([]int, len1)
//     right := make([]int, len2)
//     for i := 0; i < len1; i += 1 {
//         left[i] = it.collection[l + i]
//     }
//     for i := 0; i < len2; i += 1 {
//         right[i] = it.collection[m + 1 + i]
//     }

//     i := 0
//     j := 0
//     k := l

//     for i < len1 && j < len2 {
//         if left[i] <= right[j] {
//             it.collection[k] = left[i]
//             i += 1
//         } else {
//             it.collection[k] = right[i]
//             j += 1
//         }
//         k += 1
//     }

//     for i < len1 {
//         it.collection[k] = left[i]
//         k += 1
//         j += 1
//     }

//     for j < len2 {
//         it.collection[k] = right[j]
//         k += 1
//         j += 1
//     }
// }

// timsort_interface :: proc(it: Interface) {
//     min_run := get_min_run(it->len())

//     for i := 0; i < it->len(); i += 1 {
//         run_len := 0
//         if i + min_run - 1 < it->len() {
//             run_len = i + min_run - 1
//         } else {
//             run_len = it->len() - 1
//         }
//         insertion_sort(it, i, run_len)
//     }

//     for size := min_run; size < it->len(); size = 2 * size {
//         for left := 0; left < it->len(); left += 2 * size {
//             mid := left + size - 1
//             right := 0
//             if left + 2 * size - 1 < it->len() - 1 {
//                 right = left + 2 * size - 1
//             } else {
//                 right = it->len() - 1
//             }
//             if mid < right {
//                 merge(it, left, mid, right)
//             }
//         }
//     }
// }

// print_interface :: proc(it: Interface) {
//     for i := 0; i < it->len(); i += 1 {
//         fmt.printf("%d", it.collection[i])
//         if (i % 10 == 0) {
//             fmt.println()
//         } else {
//             fmt.printf("  ")
//         }
//     }
//     fmt.println()
// }
