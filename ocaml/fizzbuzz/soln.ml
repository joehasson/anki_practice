let fizzbuzz n =
    let i = ref 0 in
    while !i <= n do
        (match !i mod 3, !i mod 5 with
        | 0, 0 -> print_endline "FizzBuzz"
        | 0, _ -> print_endline "Fizz"
        | _, 0 -> print_endline "Buzz"
        | _, _ -> print_int !i; print_newline());
        i := !i + 1
    done

