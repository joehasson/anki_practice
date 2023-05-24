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
    type 'a seq = Seq of (unit -> 'a seqnode)
    and 'a seqnode = Nil | Cons of 'a * 'a seq

    exception Empty

    let cons x sq = Seq (fun () -> Cons (x, sq))
    
    let null (Seq sq) = match sq() with Nil -> true | _ -> false

    let empty = Seq (fun () -> Nil)

    let hd (Seq sq) = match sq () with | Nil -> failwith "Empty" | Cons (x,_) -> x

    let tl (Seq sq) = match sq () with | Nil -> failwith "Empty" | Cons (_,sq) -> sq

    let rec fromList = function | [] -> empty | (x::xs) -> cons x (fromList xs)

    let rec toList (Seq sq) = match sq () with Nil -> [] | Cons (x, sq') -> x :: toList sq'

    let rec take (Seq sq) n = 
        match sq(), n with
        | _, 0 -> []
        | Nil, _ -> failwith "Out of bounds"
        | Cons (x,sq'), i -> x :: take sq' (i-1)

    let rec drop (Seq sq) n =
        if n=0 then Seq sq
        else match sq () with
            | Nil -> failwith "Out of bounds"
            | Cons (_, sq') -> drop sq' (n-1)

    let rec ( @ ) (Seq sq1) sq2 = 
        match sq1() with
        | Nil -> sq2
        | Cons (x, sq1') -> cons x (sq1' @ sq2)

    let rec interleave (Seq fs1) (Seq fs2) = 
        match fs1(), fs2() with
        | Nil, Nil -> empty
        | Nil, _  ->  (Seq fs2)
        | Cons (x, sq), _ -> cons x (interleave (Seq fs2) sq)

    let rec map f (Seq fs) =
        match fs () with
        | Nil -> empty
        | Cons (x, sq') -> cons (f x) (map f sq')


    let rec filter f (Seq fs) = 
        match fs () with
        | Nil -> empty
        | Cons (x, sq') -> if f x then cons x (filter f sq') else filter f sq'

    let rec iterates f init = let v = f init in Seq (fun () -> Cons (v, iterates f v))

    let rec from n = Seq (fun () -> Cons (n, from (n+1)))
end
