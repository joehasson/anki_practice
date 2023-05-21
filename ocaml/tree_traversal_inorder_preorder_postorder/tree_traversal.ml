(* Three ways to traverse trees preorder, postorder, inorder *)

type tree = Lf | Br of int * tree * tree 

let example = Br (1, 
                  Br (2, 
                      Lf, 
                      Br (3,Lf, Lf)),
                  Br (4, 
                      Br(5, Lf, Lf), 
                      Br(6, Lf, Br(7, Lf, Lf))))


(* Naive way with appends. This is slow because appending lists
   is a slow operation. *)
let rec preorder = function
    | Lf -> []
    | Br (x,t1,t2) -> x :: (preorder t1 @ preorder t2)

let rec postorder = function
    | Lf -> []
    | Br (x,t1,t2) -> postorder t1 @ postorder t2 @ [x]

let rec inorder = function
    | Lf -> []
    | Br (x,t1,t2) -> inorder t1 @ (x :: inorder t2)

(* We can use accumulators to avoid list appends. *)

(* First idea: gather the nodes in an accumulator argument as they are
   visited in recursive calls. Reverse at the end. *)

let preorder2 t =
    let rec aux t acc = match t with
        | Lf -> acc
        | Br (x, t1, t2) -> aux t2 (aux t1 (x::acc))
    in List.rev (aux t [])

let postorder2 t =
    let rec aux t acc = match t with
        | Lf -> acc
        | Br (x, t1, t2) -> x :: (aux t2 (aux t1 acc))
    in List.rev (aux t [])

let inorder2 t =
    let rec aux t acc = match t with
        | Lf -> acc
        | Br (x, t1, t2) -> aux t2 (x :: (aux t1 acc))
    in List.rev (aux t [])


let test1 = preorder example = preorder2 example
let test2 = postorder example = postorder2 example
let test3 = inorder example = inorder2 example

(* This costly reversal operation can also be eliminated:
    Second idea: Exploit the fact that the list is built in
    reverse order to get it right without having to reverse.*)

let preorder3 t =
    let rec aux t acc = match t with
        | Lf -> acc
        | Br (x, t1, t2) -> x :: aux t1 (aux t2 acc)
    in aux t []

let postorder3 t =
    let rec aux t acc = match t with
        | Lf -> acc
        | Br (x, t1, t2) -> aux t1 (aux t2 (x :: acc))
    in aux t []

let inorder3 t =
    let rec aux t acc = match t with
        | Lf -> acc
        | Br (x, t1, t2) -> aux t1 (x :: (aux t2 acc))
    in aux t []

let test4 = preorder example = preorder3 example
let test5 = postorder example = postorder3 example
let test6 = inorder example = inorder3 example

