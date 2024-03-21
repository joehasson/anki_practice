let rec partition pivot = function
    | [] -> [], []
    | x :: xs ->
            let (l,r) = partition pivot xs in
            if x <= pivot
            then x :: l, r
            else l, x :: r

let sort lst =
    let rec quicksort lst sorted =
        match lst with
        | [] -> sorted
        | pivot :: xs ->
            let l,r = partition pivot xs in
            quicksort l (pivot :: quicksort r sorted)
    in quicksort lst []

