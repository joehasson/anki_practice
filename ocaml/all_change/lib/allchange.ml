let allChange target coins = 
    let rec aux tgt coins acc = match tgt, coins with
    | 0, _ -> [acc]
    | _, [] -> []
    | n, (c::cs) ->
        if c > n 
        then aux n cs acc
        else aux (n-c) (c::cs) (c::acc)
            @ aux n cs acc
    in aux target coins []

let allChangeIter target coins =
    let rec aux tgt coins acc list = match tgt, coins with
    | 0, _ -> acc::list
    | _, [] -> list
    | n, (c::cs) ->
        if c > n 
        then (aux n cs acc list)
        else aux (n-c) (c::cs) (c::acc)
                (aux n cs acc list)
    in aux target coins [] []

let test0 = List.length (allChange 16 [20;10;5;2;1]) = 25

let testIter0 = List.length (allChangeIter 16 [20;10;5;2;1]) = 25

