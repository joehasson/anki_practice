type 'a tree = Lf | Br of 'a * 'a tree * 'a tree

module type Traversals = sig
  (**[preoder t] is a list of the nodes of [t] in
     preorder*)
  val preorder: 'a tree -> 'a list

  (**[inorder t] is a list of the nodes of [t] in
     inorder*)
  val inorder: 'a tree -> 'a list

  (**[postorder t] is a list of the nodes of [t] in
     postorder*)
  val postorder: 'a tree -> 'a list
end

