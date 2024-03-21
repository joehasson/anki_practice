module type BRAUN = sig
    type t
    val empty: t
    val sub: t -> int -> int 
    val update: t -> int -> int -> t
    val delete: t -> int -> t
    val loext: t -> int -> t
    val lorem: t -> t
    val to_list: t -> int list
    val from_list: int list -> t
end

module BraunArray = struct
    type t = Lf | Br of int * t * t

    let empty = Lf

    let lsb n = n land 1

    let rec sub t i = match t, i with
    | Lf, _ -> failwith "can't subscript here"
    | Br (x, _, _), 1 -> x
    | Br (_, t1, t2), n ->
            if lsb n = 0 
            then sub t1 (i lsr 1)
            else sub t2 (i lsr 1)

    let rec update t i x = match t, i with
    | Lf, _ -> failwith "out of bounds"
    | Br (_,t1,t2), 1 -> Br (x,t1,t2)
    | Br (y, t1, t2), n -> 
            let i = i lsr 1 in
            if lsb n = 0
            then Br (y, update t1 i x, t2)
            else Br (y, t1, update t2 i x)

    let rec delete t i = match t, i with
    | Lf, _ -> failwith "out of bounds"
    | Br (_,_,_), 1 -> Lf
    | Br (y, t1, t2), n -> 
            let i = i lsr 1 in
            if lsb n = 0
            then Br (y, delete t1 i, t2)
            else Br (y, t1, delete t2 i)

    let rec loext t x = match t with
    | Lf -> Br (x, Lf, Lf)
    | Br (y, t1, t2) -> Br (x, loext t2 y, t1)

    let rec lorem t = match t with
    | Lf -> failwith "can't delete"
    | Br (_, Lf, Lf) -> Lf
    | Br (_, (Br (x, _, _) as t1), t2) -> 
            Br (x, t2, lorem t1)
    | Br (_, Lf, Br _) -> failwith "Invariant violated by this case"

    let to_list t =
        let rec size = function
        | Lf -> 0 | Br (_,t1,t2) -> 1 + size t1 + size t2
        in
        let tsize = size t in
        List.init tsize (fun i -> sub t (i+1))

    let from_list list = List.fold_right (fun x acc -> loext acc x) list empty
end

