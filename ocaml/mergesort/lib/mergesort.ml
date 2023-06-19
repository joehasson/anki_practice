let rec merge xs ys =
    match xs, ys with
    | xs, [] -> xs
    | [], ys -> ys
    | (x :: xs), (y :: ys) ->  
            if x <= y 
            then x :: merge xs (y :: ys)
            else y :: merge (x :: xs) ys

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
                    
let test1 = mergesort [] = []
let test2 = mergesort [1] = [1]
let test3 = mergesort [5;2;5;1;7;4;2;8]
let test4 = mergesort [5;2;5;1;9;7;4;2;8]
let test5 = mergesort [5;2;5;1;9;7;4;2;8;3;134;542;2;13;563;234;245;675;654;2;642;35;34567;542;21;2]

