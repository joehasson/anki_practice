let next_queens n board =
    let diag_safe n = 
        let rec aux board i = match board with
        | [] -> true
        | x :: xs -> Int.abs (n-x) <> i && aux xs (i+1)
        in aux board 1
    in
    let squares = List.init n (fun x -> x+1) in
    let safe_squares = List.filter (fun square ->
        diag_safe square && not (List.mem square board)
    ) squares
    in List.map (fun square -> square :: board) safe_squares

let dfs f init =
    let rec aux stack = match stack with
    | [] -> Seq.empty
    | x :: xs -> Seq.cons x (aux (f x @ xs))
    in aux [init]

let solve n =
    let nexts = next_queens n in
    let is_complete b = List.length b = n in
    let possibilities = dfs nexts [] in
    Seq.filter is_complete possibilities

