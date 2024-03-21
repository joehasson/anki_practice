let allChange target coins = 
    let rec aux tgt cs acc = match tgt, cs with
    | 0, _ -> [acc]
    | _, [] -> []
    | n, (c::cs) ->
        aux (n-c) (c::cs) (c::acc)
        @ aux n cs (acc)
    in aux target coins []

let allChangeIter _target _coins =
    []

let test0 = List.length (allChange 16 [20;10;5;2;1]) = 25

let testIter0 = List.length (allChangeIter 16 [20;10;5;2;1]) = 25

