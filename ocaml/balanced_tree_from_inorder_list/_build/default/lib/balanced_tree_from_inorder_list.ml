type 'a t = 
    | Lf 
    | Br of 'a * 'a t * 'a t

let rec convert list =
    let rec split list at = 
        match list, at with
        | [], 0 -> [], []
        | [], _ -> failwith "Out of bounds"
        | x :: xs, 0 -> [], x :: xs
        | x :: xs, i -> let left, right = split xs (i - 1) in x :: left, right
    in
    let left, right = split list (List.length list / 2)
    in match left, right with
    | xs, y :: ys -> Br (y, convert xs, convert ys)
    | x :: _, [] -> Br (x, Lf, Lf)
    | [], [] -> Lf

