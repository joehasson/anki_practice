type 'a tree = Lf | Br of 'a * 'a tree * 'a tree

let rec all_splits = function
    | [] -> [[], []]
    | x :: xs -> 
            List.fold_right (fun way_of_splitting ways ->
                match way_of_splitting with
                | [], ys -> 
                        let start_left_split = [x], ys in
                        let continue_right_split = [], x::ys in
                        start_left_split :: continue_right_split :: ways
                | xs, ys -> (x :: xs, ys) :: ways
            ) (all_splits xs) []


let rec cartprod lst1 lst2 = match lst1 with
    | x::xs -> List.map (fun y -> x,y) lst2 @ cartprod xs lst2
    | [] -> []


let rec all_trees t = 
    match t with
    | [] -> [Lf]
    | root :: xs ->
            let left_right_descendant_combos = all_splits xs in
            let left_right_subtree_combos = 
                List.fold_right (fun (left_nodes, right_nodes) acc ->
                    let possible_left_subtrees = all_trees left_nodes in
                    let possible_right_subtrees = all_trees right_nodes in
                    let pairs = cartprod possible_left_subtrees possible_right_subtrees in
                    pairs @ acc
                ) left_right_descendant_combos []
            in List.map (fun (t1, t2) -> Br(root, t1, t2)) left_right_subtree_combos

