include Interf

module Impl1 : Traversals = struct
    let preorder t =
        let rec aux acc = function
            | Lf -> acc
            | Br (x,t1,t2) ->
                    aux (aux (x::acc) t1) t2
        in List.rev (aux [] t)
    
    let inorder t =
        let rec aux acc = function
            | Lf -> acc
            | Br (x,t1,t2) ->
                    aux (x :: aux acc t1) t2
        in List.rev (aux [] t)

    let postorder t =
        let rec aux acc = function
            | Lf -> acc
            | Br (x,t1,t2) ->
                    x :: aux (aux acc t1) t2
        in List.rev (aux [] t)
end


module Impl2 : Traversals = struct
    let preorder t =
        let rec aux acc = function
            | Lf -> acc
            | Br (x,t1,t2) ->
                    x :: aux (aux acc t2) t1
        in aux [] t

    let inorder t =
        let rec aux acc = function
            | Lf -> acc
            | Br (x,t1,t2) ->
                    aux (x :: aux acc t2) t1
        in aux [] t

    let postorder t =
        let rec aux acc = function
            | Lf -> acc
            | Br (x,t1,t2) ->
                    aux (aux (x :: acc) t2) t1
        in aux [] t
end

