module type SEQUENCE = sig
    type 'a seq
    exception Empty
    val cons :'a -> 'a seq -> 'a seq
    val null : 'a seq -> bool
    val hd : 'a seq -> 'a
    val tl : 'a seq -> 'a seq
    val fromList : 'a list -> 'a seq
    val toList : 'a seq -> 'a list
    val take : 'a seq -> int -> 'a list
    val drop : 'a seq -> int -> 'a seq
    val ( @ ) : 'a seq -> 'a seq -> 'a seq
    val interleave : 'a seq -> 'a seq -> 'a seq
    val map : ('a -> ' b) -> 'a seq -> ' b seq
    val filter : ('a -> bool) -> 'a seq -> 'a seq
    val iterates : ('a -> 'a) -> 'a -> 'a seq
    val from: int -> int seq
end

module Sequence : SEQUENCE  = struct
    type 'a seqnode = Cons of 'a * 'a seq | Nil
    and 'a seq = unit -> 'a seqnode

    exception Empty

    let cons x seq = fun () -> Cons (x, seq)

    let null = fun () -> Nil

    let hd seq = match seq () with
    | Nil -> raise Empty
    | Cons (x, _) -> x

    let tl seq = match seq () with
    | Nil -> raise Empty
    | Cons (_, seq') -> seq'

    let rec fromList = function
    | [] -> null
    | x :: xs -> cons x (fromList xs)

    let rec toList sq = match sq() with
    | Nil -> []
    | Cons (x, sq') -> x :: toList sq'

    let rec take sq n =
        if n=0
        then []
        else match sq () with
        | Nil -> raise Empty
        | Cons (x, sq') -> x :: take sq' (n-1)

    let rec drop sq n =
        if n=0
        then sq
        else match sq () with
        | Nil -> raise Empty
        | Cons (_, sq') -> drop sq' (n-1)
end
