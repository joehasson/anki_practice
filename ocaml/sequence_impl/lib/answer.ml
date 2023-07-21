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

module Sequence : SEQUENCE = struct
    type 'a seq = unit -> 'a seqnode
    and 'a seqnode = Nil | Cons of 'a * 'a seq

    exception Empty

    let cons x sq = fun () -> Cons (x, sq)
    let null sq = match sq() with | Nil -> true | Cons _ -> false
    let hd sq = match sq() with | Cons (x,_) -> x | Nil -> raise Empty
    let tl sq = match sq() with | Cons (_,sq') -> sq' | Nil -> raise Empty

    let rec fromList lst = 
        match lst with 
        | [] -> fun () -> Nil
        | x :: xs -> cons x (fromList xs)

    let rec toList sq =
        match sq () with
        | Nil -> []
        | Cons (x, sq') -> x :: (toList sq')

    let rec take sq n =
        match sq(), n with
        | _, 0 -> []
        | Nil, _ -> raise Empty
        | Cons (x,sq'), n -> x :: (take sq' (n-1))

    let rec drop sq n = 
        match sq(), n with
        | _, 0 -> sq
        | Nil, _ -> raise Empty
        | Cons (_, sq'), n -> drop sq' (n-1)

    let rec ( @ ) sq1 sq2 =
        match sq1() with
        | Nil -> sq2
        | Cons (x, sq') ->  cons x (sq' @ sq2)

    let rec interleave sq1 sq2 =
        match sq1() with
        | Nil -> sq2
        | Cons (x, sq1') -> cons x (interleave sq2 sq1')

    let rec map f sq = 
        match sq () with
        | Nil -> fun () -> Nil
        | Cons (x, sq') -> cons (f x) (map f sq')

    let rec filter f sq = 
        match sq () with
        | Nil -> fun () -> Nil
        | Cons (x, sq') when f x -> cons x (filter f sq') 
        | Cons (_, sq') -> filter f sq'

    let rec iterates f init =
        fun () -> Cons (init, iterates f (f init))

    let rec from init =
        fun () -> Cons (init, from (init + 1))
end
