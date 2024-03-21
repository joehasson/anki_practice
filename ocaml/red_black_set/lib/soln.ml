(* We maintain the following invariants 
   - BST invariant
   - Local invariant: never red node with red child
   - global invariant: all root -> lf paths have
     equal # of black nodes
*)
type color = Red | Black

type t = Lf | Br of color * int * t * t

let empty = Lf

let rebalance = function
    (* Tree can be out of balance in the following ways. Symmetrical cases are grouped
        in pairs *)
    (*
               Black z                  Black x
            /          \             /        \
          Red y         D           A          Red y
          /    \                                /  \
        Red x   C                              B    Red z
        /  \                                        /  \
      A     B                                       C   D
    *)
    | Br (Black, z, Br (Red, y, Br (Red, x, a, b), c), d)
    | Br (Black, x, a, Br (Red, y, b, Br (Red, z, c, d)))
    (*
               Black z                      Black x
            /          \                  /         \
          Red x         D                A           Red z
          /  \                                       /  \
         A   Red y                               Red y   D
              / \                                /  \
             B   C                              B   C
    *)
    | Br (Black, z, Br (Red, x, a, Br (Red, y, b, c)), d)
    | Br (Black, x, a, Br (Red, z, Br (Red, y, b, c), d))
    (* In all cases, the following fixes the imbalance locally 
                    Red y
                  /       \
              Black x     Black z
              /  \         /  \
             A    B       C     D
    *)
        -> Br (Red, y, Br (Black, x, a, b), Br (Black, z, c, d))
    (* all other cases the tree is already balanced *)
    | t -> t

let rec insert_aux t x = match t with
    | Lf -> Br (Red, x, Lf, Lf)
    | Br (c, y, t1, t2) ->
            if x < y 
            then Br (c, y, insert_aux t1 x, t2) |> rebalance
            else if x=y then Br (c, y, t1, t2)
            else Br (c, y, t1, insert_aux t2 x)

let insert t x =
    match insert_aux t x with
    | Lf -> failwith "Impossible"
    | Br (_, x, t1, t2) -> Br (Black, x, t1, t2)

let fold_inorder_left f acc t =
    let rec aux t acc = match t with
    | Lf -> acc
    | Br (_, v, t1, t2) -> aux t2 (f (aux t1 acc) v)
    in aux t acc

let fold_inorder_right f acc t =
    let rec aux t acc = match t with
    | Lf -> acc
    | Br (_, v, t1, t2) -> aux t1 (f (aux t2 acc) v)
    in aux t acc

let to_list t =
    fold_inorder_right (fun acc n -> n :: acc) [] t

let from_list list =
    List.fold_left insert empty list

let size t = 
    fold_inorder_left (fun acc _ -> acc + 1) 0 t 

let mem t x =
    fold_inorder_left (fun acc v -> acc || v=x) false t
