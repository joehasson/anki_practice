include Interf

(*First Idea: exploit evaluation order*)
module Impl1 : Traversals = struct
  let preorder t =
      let rec aux t acc = match t with
        | Lf -> acc
        | Br (x,t1,t2) -> aux t2 (aux t1 (x::acc))
      in List.rev (aux t [])

  let inorder t = 
      let rec aux t acc = match t with
        | Lf -> acc
        | Br (x,t1,t2) -> aux t2 (x :: aux t1 acc)
      in List.rev (aux t [])

  let postorder t =
      let rec aux t acc = match t with
        | Lf -> acc
        | Br (x,t1,t2) -> x :: aux t2 (aux t1 acc)
      in List.rev (aux t [])
end

(*Second idea: be clever about evaluation order *)
module Impl2 : Traversals= struct
  let preorder t =
      let rec aux t acc = match t with
        | Lf -> acc
        | Br (x,t1,t2) -> x :: aux t1 (aux t2 acc)
      in aux t []

  let inorder t = 
      let rec aux t acc = match t with
        | Lf -> acc
        | Br (x,t1,t2) -> aux t1 (x :: aux t2 acc)
      in aux t []

  let postorder t =
      let rec aux t acc = match t with
        | Lf -> acc
        | Br (x,t1,t2) -> aux t1 (aux t2 (x :: acc))
      in aux t []
end

