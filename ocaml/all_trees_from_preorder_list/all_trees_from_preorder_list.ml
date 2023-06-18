type 'a tree = Lf | Br of 'a * 'a tree * 'a tree

let rec cartprod l r = 
    match l, r with
    | [], _      -> []
    | x :: xs, ys -> 
            let rec pairx = function
                | [] -> cartprod xs ys
                | y :: ys -> (x,y) :: pairx ys
            in pairx ys

let rec split_at n lst = 
    match lst, n with
    | lst, 0     -> [], lst
    | [], _      -> failwith "out of bounds"
    | x :: xs, n -> let left, right = split_at (n-1) xs in x :: left, right

let rec all_trees = function
    | [] -> [Lf]
    | x :: xs -> 
        let subtree_pairs i =
            let left, right = split_at i xs
            in cartprod (all_trees left) (all_trees right)
        in
        let all_pairs =
            let rec build n =
                if n=0 then subtree_pairs 0 
                else subtree_pairs n @ build (n-1)
            in build (List.length xs)
        in List.map (fun (l,r) -> Br (x,l,r)) all_pairs


let foo = (List.length (all_trees [])) = 1
let bar = (List.length(all_trees [1;2;3])) = 5
let baz = (List.length(all_trees [1;2;3;4;5;6])) = 132

