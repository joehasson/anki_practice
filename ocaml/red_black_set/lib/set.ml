(* We maintain the invariants
   i) BST invariant
   ii) local invariant: red nodes have only black chldrn
   iii) global invariant: # of black nodes on root -> leaf
        is equal
*)

type color = Red | Black

type leaf
type branch

type _ t = 
  | Lf: leaf t 
  | Br: int * color * _ t * _ t -> branch t

let rebalance: branch t -> branch t = function
(* All of the ways an rb can have the local invariant violated *)
(*              B z
              /     \
            Red y    D
            /  \
         Red x  C
         /  \
        A    B
*)
| Br (z, Black, Br (y, Red, Br (x, Red, a, b), c), d)
(*              B z
               /   \
            Red x    D
            /   \
           A     Red y
                  /  \
                 B    C
*)
| Br (z, Black, Br (x, Red, a, Br (y, Red, b, c)), d)
(*              B x
                /  \
               A    Red z
                    /    \
                  Red y   D
                  /  \
                  B  C
*)
| Br (x, Black, a, Br (z, Red, Br (y, Red, b, c), d))
(*              B x
                /  \
               A    Red y
                    /    \
                   B      Red z
                          /  \
                          C   D
*)
| Br (x, Black, a, Br (y, Red, b, Br (z, Red, c, d)))
(* All of these imbalances are fixed locally by
                 Red y
                /     \
             Black x   Black z
              /   \      /    \
             A    B     C      D
*) -> Br (y, Red, Br (x, Black, a, b), Br (z, Black, c, d))
(* Everything else is already balanced *)
| t -> t

let rec insert_aux: type a. a t -> int -> branch t = fun t x -> match t with
| Br (y,c,t1,t2) ->
    if x=y then t
    else if x < y then Br (y, c, insert_aux t1 x, t2) |> rebalance
    else Br (y, c, t1, insert_aux t2 x) |> rebalance
| Lf -> Br (x, Red, Lf, Lf)

let insert t x = 
    let Br (y,_,t1,t2) = insert_aux t x in Br (y, Black, t1, t2)

let fold_inorder: type a. (int -> 'acc -> 'acc) -> 'acc -> a t -> 'acc = fun f init t ->
    let rec aux: type b. b t -> 'acc -> 'acc = fun t acc -> match t with
    | Lf -> acc
    | Br (x,_,t1,t2) -> f x (aux t1 (aux t2 acc))
    in aux t init

let to_list = fold_inorder List.cons []
let size t = fold_inorder (fun _ acc -> acc + 1) 0 t
let empty = Lf

let rec from_list: type a. int list -> a t = function
    | [] -> Lf
    | x :: xs -> insert x (from_list xs)

let rec mem: type a. a t -> int -> bool = 
    fun t x -> match t with
    | Lf -> false
    | Br (y,_,t1,t2) ->
        if x=y then true
        else if x < y then mem t1 x
        else mem t2 x

