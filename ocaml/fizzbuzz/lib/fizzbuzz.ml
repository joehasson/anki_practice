let fizzbuzz n =
    let counter = ref 0 in
    while !counter <= n do
        (match !counter mod 3, !counter mod 5 with
        | 0, 0 -> print_endline "FizzBuzz"
        | 0, _ -> print_endline "Fizz"
        | _, 0 -> print_endline "Buzz"
        | _, _ -> print_endline (string_of_int !counter))
        ; counter := !counter + 1 
    done
