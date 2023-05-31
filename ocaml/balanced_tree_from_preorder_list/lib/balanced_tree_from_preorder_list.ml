type 'a tree = Lf | Br of 'a * 'a tree * 'a tree

let split_at n list = 
    let rec aux = function
        | xs, 0 -> [], xs
        | x::xs, i -> let left, right = aux (xs, i-1) in (x :: left), right
        | [], _ -> invalid_arg "n greater than list length"
    in aux (list, n)

let rec balanced_from_preorder_list = function
    | [] -> Lf
    | x::xs ->
            let left, right = split_at (List.length xs / 2) xs 
            in Br (x, balanced_from_preorder_list left, balanced_from_preorder_list right)
            
