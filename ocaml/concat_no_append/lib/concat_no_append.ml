let rec concat_no_append = function
    | [] -> []
    | []::xss -> concat_no_append xss
    | (x::xs)::xss -> x :: concat_no_append (xs::xss)

let foo = concat_no_append [[1;2;3];[4;5];[6];[7;8;9;10]]
