open Tree_traversal

module RefImpl: Traversals = struct
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
end
