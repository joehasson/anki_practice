let dfs nexts init =
    let rec aux stack = match stack with
    | [] -> Seq.empty
    | x :: xs -> fun () -> Seq.Cons (x, aux (nexts x @ xs))
    in aux [init]

let next_safe_boards size oldqs =
    let no_diags q qs =
        let rec aux i qs = match qs with
        | [] -> true
        | x :: xs -> Int.abs (q - x) <> i && aux (i+1) xs
        in aux 1 qs
    in
    let positions = List.init size (fun x -> x) 
    in
    let safe_positions = 
        List.filter (fun p -> no_diags p oldqs && not (List.mem p oldqs)) positions
    in List.map (fun p -> p :: oldqs) safe_positions

let solve n =
    let is_complete board = List.length board = n  in
    let safe_boards = dfs (next_safe_boards n) [] in
    Seq.filter is_complete safe_boards

