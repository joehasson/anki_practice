module type BRAUN = sig
    type t
    val sub: t -> int -> int 
    val update: t -> int -> int -> t
    val delete: t -> int -> t
    val loext: t -> int -> t
    val lorem: t -> t
    val to_list: t -> int list
    val from_list: int list -> t
end

module BraunArray : BRAUN = struct
    type t = Lf | Br of int * t * t

    (**[sub t i] is the [i]th value in [t]*)
    let rec sub t i = match t, i with
        | Lf, _ -> failwith "sub Out of bounds"
        | Br (x, t1, t2), i -> if i=1 then x
                               else if i mod 2 = 0 then sub t1 (i / 2)
                               else sub t2 (i / 2)
        
    (**[update t i x] sets the [i]th value of [t] to [v]*)
    let rec update t i x = match t, i, x with
        | Lf, _, _ -> failwith "update Out of bounds"
        | Br (e, t1, t2), i, x -> if i=1 then Br(x, t1, t2)
                                  else if i mod 2 = 0 then Br (e, update t1 (i / 2) x, t2)
                                  else Br (e, t1, update t2 (i / 2) x)

    (**[delete t i] deletes the subtree rooted at [i]*)
    let rec delete t i = match t, i with
        | Lf, _ -> failwith "delete Out of bounds"
        | Br(x,t1,t2), i -> if i=1 then Lf
                            else if i mod 2 = 0 then Br(x, delete t1 (i / 2), t2)
                            else Br (x, t1, delete t2 (i / 2))

    (**[loext t x] adds [x] to the start of [t]*)
    let rec loext t x = match t with
        | Lf -> Br (x, Lf, Lf)
        | Br (e, t1, t2) -> Br (x, loext t2 e, t1)

    (**[lorem t] deletes the first element of [t]*)
    let rec lorem = function
        | Lf -> failwith "lorem Out of bounds"
        | Br(_, Lf, Lf) -> Lf
        | Br(_, Lf, _) -> failwith "Impossible"
        | Br(_, Br(y,l,r), t2) -> Br (y, t2, lorem (Br(y,l,r)))

    let to_list t = 
        let rec size = function
            | Lf -> 0
            | Br (_,t1,t2) -> 1 + size t1 + size t2
        in List.init (size t) (fun x -> sub t (x+1))

    let rec from_list = function
        | [] -> Lf
        | (x::xs) -> loext (from_list xs) x
end

(* Tests *)

open BraunArray
let testval = from_list [1;2;3;4;5];;
let test1 = sub testval 3
let test0 = to_list (lorem testval)
let test0' = to_list (lorem (from_list test0))
let test0'' = to_list (lorem (from_list test0'))
let test0''' = to_list (lorem (from_list test0''))
let test0'''' = to_list (lorem (from_list test0'''))

let testval2 = from_list [1;2;3;4;5];;
let test1 = to_list (loext (loext testval2 0) 200)
let test2 = to_list (update testval2 3 1000)

let test3 = List.mapi (fun i e -> e = sub testval (i+1)) (to_list testval)

