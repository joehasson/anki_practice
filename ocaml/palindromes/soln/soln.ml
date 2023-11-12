type 'a seqnode = Cons of 'a * 'a seq | Nil
and 'a seq = unit -> 'a seqnode

exception Empty

let alphabet = ['a';'b';'c']

let hd sq = match sq () with
    | Cons (x,_) -> x
    | Nil -> raise Empty

let tl sq = match sq () with
    | Cons (_,sq') -> sq'
    | Nil -> raise Empty

let rec seq_filter f sq = match sq () with
    | Cons (x,sq') -> 
            if f x 
            then fun () -> Cons (x, seq_filter f sq')
            else seq_filter f sq'
    | Nil -> sq

let rec seq_map f sq = match sq () with
    | Cons (x,sq') -> fun () -> Cons (f x, seq_map f sq')
    | Nil -> fun () -> Nil

let rec seq_take sq n = match sq(), n with
    | _, 0 -> []
    | Nil, _ -> raise Empty
    | Cons(x,sq'), n -> x :: seq_take sq' (n-1)

let children_of parent = 
    List.map (fun c -> c :: parent) alphabet

let is_palindrome s =
    s = List.rev s

let seq_bfs f init =
    let q = Queue.create () in
    let enqueue x = Queue.add x q in
    let () = enqueue init in
    let rec seq = fun () ->
        let x = Queue.pop q in
        let () = List.iter enqueue (f x) in
        Cons (x, seq)
    in seq

let palindromes = 
    seq_filter is_palindrome (seq_bfs children_of [])

let () = 
    let string_of_chars chars = 
        let buf = Buffer.create (List.length chars) in
        let () = List.iter (Buffer.add_char buf) chars in
        Buffer.contents buf
    in
    let palstrings = seq_map string_of_chars palindromes in
    List.iter print_endline (seq_take palstrings 100 )

