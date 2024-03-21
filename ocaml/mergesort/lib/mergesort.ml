let rec merge xs ys = match xs, ys with
| [], ys -> ys
| xs, [] -> xs
| x :: xs', y :: ys' -> 
        if x <= y
        then x :: merge xs' ys
        else y :: merge xs ys'

let split_midway list =
    let mid = List.length list / 2 in
    List.filteri (fun i _ -> i < mid) list,
    List.filteri (fun i _ -> i >= mid) list

let rec tmergesort = function
| [x] -> [x]
| [] -> []
| list ->
    let left, right = split_midway list
    in merge (tmergesort left) (tmergesort right)

let mergesort list = ignore list; []

