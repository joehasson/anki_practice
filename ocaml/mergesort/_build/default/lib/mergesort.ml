let rec merge xs ys =
    match xs, ys with
    | xs, [] -> xs
    | [], ys -> ys
    | (x :: xs), (y :: ys) ->  
            if x <= y 
            then x :: merge xs (y :: ys)
            else y :: merge (x :: xs) ys

(* Bottom up version *)

