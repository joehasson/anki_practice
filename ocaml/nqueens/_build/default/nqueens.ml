type 'a seq = Nil | Cons of 'a * (unit -> 'a seq)


let rec seq_filter f sq = match sq with
    | Nil -> Nil
    | Cons (x, xf) -> if f x 
                      then Cons (x, fun () -> seq_filter f (xf ()))
                      else seq_filter f (xf ())
    

let dfs nexts init =
    let rec stack_maintainer = function
        | [] -> Nil
        | (x::stack) -> Cons (x, fun () -> stack_maintainer (nexts x @ stack))
    in stack_maintainer [init]


let nexts dim oldqs =
    let newqs = List.init dim (fun i -> (i+1)::oldqs) in
    let 
        no_diags q board = 
            let rec iterfunc i = function
                | [] -> true
                | (q'::qs) -> Int.abs(q-q') <> i && iterfunc (i+1) qs
            in iterfunc 1 board
    in
    let 
        (* Check whether q has been placed safely in qs given qs is safe *)
        safeqs = function 
            | [] -> failwith "impossible" 
            | (q::qs) -> not (List.mem q qs) && no_diags q qs
    in
        List.filter safeqs newqs


let nqueens dim = 
    let is_full_board = fun l -> List.length l == dim in
    seq_filter is_full_board (dfs (nexts dim) [])

