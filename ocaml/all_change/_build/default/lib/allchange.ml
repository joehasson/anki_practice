let allChange val coins =
    let rec impl val coins acc =
        match val, coins, acc with
        | x, _, _ when x < 0 -> []
        | 0, _, acc          -> [acc]
        | x, [], acc         -> []
        | x, c :: cs, acc    -> impl (x-c) (c :: cs) (c :: acc) @ impl x cs acc
    in impl val coins []

let foo = allChange 16 [20;10;5;2;1]

