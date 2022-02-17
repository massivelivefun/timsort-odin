print_array :: proc(array: []$T) {
    for i := 0; i < len(array); i += 1 {
        fmt.printf("%d  ", array[i])
    }
    fmt.println()
}

main :: proc() {
    array := [15]int{-2, 7, 15, -14, 0, 15, 0, 7, -7, -4, -13, 5, 8, -14, 12}
    slice := array[:]

    print_array(slice)
    tim_sort(slice)
    print_array(slice)
}
