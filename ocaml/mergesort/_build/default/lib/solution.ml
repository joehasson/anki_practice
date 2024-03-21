let rec merge xs ys =
    match xs, ys with
    | xs, [] -> xs
    | [], ys -> ys
    | (x :: xs), (y :: ys) ->  
            if x <= y 
            then x :: merge xs (y :: ys)
            else y :: merge (x :: xs) ys

let split_midway lst =
    let mid = List.length lst / 2 in
    let rec aux xs i = 
        match xs, i with
        | [], _ -> [], []
        | x :: xs, i ->
                let left, right = aux xs (i+1) in
                if i < mid 
                then x :: left, right
                else left, x :: right
    in aux lst 0


(* Top down version *)
let rec tmergesort = function
    | [] -> []
    | [x] -> [x]
    | lst -> 
        lst 
        |> split_midway 
        |> (fun (l,r) -> tmergesort l, tmergesort r)
        |>  (fun (l,r) -> merge l r)

let ttest1 = tmergesort [] = []
let ttest2 = tmergesort [1] = [1]
let ttest3 = tmergesort [5;2;5;1;7;4;2;8]
let ttest4 = tmergesort [5;2;5;1;9;7;4;2;8]
let ttest5 = tmergesort [5;2;5;1;9;7;4;2;8;3;134;542;2;13;563;234;245;675;654;2;642;35;34567;542;21;2]

(* Bottom up version *)
let rec mergepairs lst i =
    match lst, i with
    | (x :: y :: xs), i when i mod 2 = 0 -> mergepairs (merge x y :: xs) (i / 2)
    | lst, _ -> lst

let mergesort = function
    | [] -> []
    | lst ->
            let rec aux lst sorted i =
                match lst, sorted, i with
                | [], sorted, _ -> List.hd (mergepairs sorted 0)
                | x :: xs, sorted, i ->
                        aux xs (mergepairs ([x] :: sorted) (i+1)) (i+1)
            in aux lst [] 0
                    


