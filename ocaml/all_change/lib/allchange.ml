let allChange v coins =
    let rec impl v coins acc =
        match v, coins, acc with
        | x, _, _ when x < 0 -> []
        | 0, _, acc          -> [acc]
        | _, [], _         -> []
        | x, c :: cs, acc    -> impl (x-c) (c :: cs) (c :: acc) @ impl x cs acc
    in impl v coins []

let allChangeIter v coins =
    let rec impl v coins acc res =
        match v, coins, acc with
        | x, _, _ when x < 0 -> res
        | 0, _, acc          -> acc :: res
        | _, [], _           -> res
        | x, c :: cs, acc    -> impl (x-c) (c :: cs) (c :: acc) (impl x cs acc res)
    in impl v coins [] []

let test0 = List.length (allChange 16 [20;10;5;2;1]) = 25

let testIter0 = List.length (allChangeIter 16 [20;10;5;2;1]) = 25

