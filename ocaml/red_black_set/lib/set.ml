type color = Red | Black
type t = Lf of color | Br of color * int * t * t

let empty = Lf Black

let fold op init set =
    let rec aux set acc = match set with
        | Lf _ -> acc
        | Br (_,x,t1,t2) -> aux t2 (aux t1 (op acc x))
    in aux set init

let balance = function
    | Br (Black, z, Br (Red, y, Br (Red, x, t1, t2), t3), t4)
    | Br (Black, z, Br (Red, x, t1, Br (Red, y, t2, t3)), t4)
    | Br (Black, x, t1, Br (Red, z, Br (Red, y, t2, t3), t4))
    | Br (Black, x, t1, Br (Red, y, t2, Br (Red, z, t3, t4)))
     -> Br (Red, y, Br (Black, x, t1, t2), Br (Black, z, t3, t4))
    | t -> t

let rec insert_aux set x = match set with
    | Lf _ -> Br (Red, x, empty, empty)
    | Br (c,y,t1,t2) ->
        if x=y then Br (c,x,t1,t2)
        else if x < y then balance (Br (c,y,insert_aux t1 x, t2))
        else balance (Br (c,y,t1, insert_aux t2 x))

let insert set x =
    match insert_aux set x with
    | Lf _ -> failwith "Impossible"
    | Br (_,x,t1,t2) -> Br (Black,x,t1,t2)


let to_list = fold (fun l i -> i :: l) []

let from_list lst = List.fold_left insert empty lst

let size = fold (fun acc _ -> acc + 1) 0

let mem set x = fold (fun acc y -> acc || x=y) false set

