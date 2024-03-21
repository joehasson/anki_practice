(**
open OUnit2

let test1 = preorder example = preorder2 example
let test2 = postorder example = postorder2 example
let test3 = inorder example = inorder2 example

let example = Br (1, 
                  Br (2, 
                      Lf, 
                      Br (3,Lf, Lf)),
                  Br (4, 
                      Br(5, Lf, Lf), 
                      Br(6, Lf, Br(7, Lf, Lf))))
*)
