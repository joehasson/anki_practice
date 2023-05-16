type 'a tree = Lf | Br of 'a * 'a tree * 'a tree

let split n lst = 
  let rec aux i rest acc = match i, rest, acc with
    | 0, rest, acc -> (List.rev acc, rest)
    | i, (x::rest), acc ->  aux (i-1) rest (x::acc)
    | _, [], _ -> failwith "n greater than list length"
  in aux n lst []

let rec cartprod xs ys = match xs, ys with
    | [], _ -> []
    | (x::xs), ys -> List.map (fun y -> (x,y)) ys @ (cartprod xs ys)

let rec all_trees = function
    | [] -> [Lf]
    | (root::xs) -> 
            let subtree_pairs i = 
                let left, right = split i xs 
                in cartprod (all_trees left) (all_trees right)
            in
            let all_pairs =
                let rec buildpairs = function 
                                    | 0 -> subtree_pairs 0 
                                    | i -> subtree_pairs i @ buildpairs (i-1)
                in buildpairs (List.length xs)
            in
            List.map (fun (t1,t2) -> Br(root,t1,t2)) all_pairs


let foo = (List.length (all_trees []))
let bar = (List.length(all_trees [1;2;3]))
let baz = (List.length(all_trees [1;2;3;4;5;6]))
