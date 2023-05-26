let _ = 
    let i = ref 0 in
        while !i <= 100 do
            ((match !i mod 3, !i mod 5 with
            | 0, 0 -> print_string "FizzBuzz"
            | 0, _ -> print_string "Fizz"
            | _, 0 -> print_string "Buzz"
            | _, _ -> print_int (!i))
            ; print_newline ()
            ; i := !i + 1
            )
        done

