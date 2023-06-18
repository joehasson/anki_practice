let rec is_12repeat lst = 
    let rec seek1 = function
        | [] -> true
        | 1 :: xs -> seek2 xs
        | _ :: xs -> false
    and seek2 = function
        | [] -> false
        | 2 :: xs -> seek1 xs
        | _ :: xs -> false
    in seek1 lst

let test1 = is_12repeat [] = true
let test2 = is_12repeat [1] = false
let test3 = is_12repeat [1;2] = true
let test4 = is_12repeat [1;2;1;2;1;2;1;2;1;2] = true
let test5 = is_12repeat [1;2;2;1;2;1;2;1;2] = false
let test6 = is_12repeat [1;2;1;2;1;2;1;2;1] = false

