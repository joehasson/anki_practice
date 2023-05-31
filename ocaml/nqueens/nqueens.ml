type 'a seq = Nil | Cons of 'a * (unit -> 'a seq)

let dfs nexts init =
    let rec aux = function
        | [] -> Nil
        | x::stack -> Cons (x, fun () -> aux (nexts x @ stack))
    in aux [init]

let rec seq_filter f = function
    | Nil -> Nil
    | Cons (a, fsq) -> 
            let sq = fsq () in 
            if f a 
            then Cons (a, fun () -> seq_filter f sq) 
            else seq_filter f sq

let rec seq_len = function
    | Nil -> 0
    | Cons (_, fsq) -> 1 + seq_len (fsq())

let nqueen_solutions n = 
    let next_queens board =
        let is_safe new_q = 
            let no_diags new_q =
                let rec aux i qs = 
                    match qs with
                    | [] -> true
                    | q::qs' -> (Int.abs(new_q - q) <> i) && aux (i+1) qs'
                in aux 1 board
            in
            no_diags new_q && not (List.mem new_q board)
        in
        let safe_qs = List.filter is_safe (List.init n (fun n -> n + 1)) in 
        List.map (fun q -> q :: board) safe_qs 
    in
    seq_filter (fun qs -> List.length qs = n) (dfs next_queens [])

let sol8 = seq_len(nqueen_solutions 8)
let sol3 = seq_len(nqueen_solutions 4)
let sol3 = seq_len(nqueen_solutions 3)

