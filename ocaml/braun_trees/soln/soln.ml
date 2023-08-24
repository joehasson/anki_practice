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

module BraunArray : BRAUN = struct
    type t = Lf | Br of int * t * t

    let empty = Lf

    let rec sub t i = match t, i with
    | Lf, _ -> failwith "Out of bounds"
    | Br(x,_,_), 1 -> x
    | Br(_,t1,t2), i -> 
            if i mod 2 = 0 
            then sub t1 (i / 2) 
            else sub t2 (i / 2)

    let rec update t i y = match t, i with
    | Lf, _ -> failwith "Out of bounds"
    | Br (_,t1,t2), 1 -> Br (y,t1,t2)
    | Br(x,t1,t2), i -> 
            if i mod 2 = 0 
            then Br(x, update t1 (i / 2) y, t2)
            else Br(x, t1, update t2 (i / 2) y)

    let rec delete t i = match t, i with
    | Lf, _ -> failwith "Out of bounds"
    | Br _, 1 -> Lf
    | Br(x,t1,t2), i -> 
            if i mod 2 = 0 
            then Br(x, delete t1 (i / 2), t2)
            else Br(x, t1, delete t2 (i / 2))

    let rec loext t x = match t with
    | Lf -> Br (x, Lf, Lf)
    | Br (y, t1, t2) -> Br (x, loext t2 y, t1)

    let rec lorem t = match t with
    | Lf -> failwith "Out of bounds"
    | Br (_,Lf,Lf) -> Lf
    | Br(_,Lf,_) -> failwith "Impossible case"
    | Br(_, (Br(y,_,_) as t1), t2) -> Br (y, t2, lorem t1)

    let to_list t =
        let rec size = function
            | Lf -> 0
            | Br(_,t1,t2) -> 1 + size t1 + size t2
        in List.init (size t) (fun i -> sub t (i+1))

    let from_list list = 
        List.fold_right (fun i t -> loext t i) list Lf 
end

