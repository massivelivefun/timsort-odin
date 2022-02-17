package main

import "core:intrinsics"

Interface :: sort.Interface
slice_interface :: sort.slice_interface

main :: proc() {
    array := [15]int{-2, 7, 15, -14, 0, 15, 0, 7, -7, -4, -13, 5, 8, -14, 12}
    slice := array[:]

    print_array(slice)
    tim_sort(slice)
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

tim_sort_proc :: proc(array: $A/[]$T, f: proc(T, T) -> int) {
    merge :: proc(a: A, start, mid, end: int, f: proc(T, T) -> int) {
        s, m := start, end

        s2 := m + 1
        if f(a[m], a[s2]) <= 0 {
            return
        }

        for s <= m && s2 <= end {
            if f(a[s], a[s2]) <= 0 {
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
    insertion_sort :: proc(a: A, start, end: int, f: proc(T, T) -> int) {
        for i in start+1..end {
            for j := i; j > start && f(a[j], a[j-1]) <= 0; j -= 1 {
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
        insertion_sort(array, i, run_len, f)
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
                merge(array, left, mid, right, f)
            }
        }
    }
}

tim_sort :: proc(array: $A/[]$T) where intrinsics.type_is_ordered(T) {
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
        for i in start+1..end {
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
