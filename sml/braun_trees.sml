datatype 'a tree = Lf | Br of 'a * 'a tree * 'a tree

signature BRAUN = sig
  val sub: 'a tree * int -> 'a (*get the ith element*)
  val update: 'a tree * int * 'a -> 'a tree (* Change element held at i *)
  val delete: 'a tree * int -> 'a tree (* Delete the subtree rooted at i *)
  val loext: 'a tree * 'a -> 'a tree  (* Add an element to the start *)
  val lorem: 'a tree -> 'a tree (* Remove the start element *)
end

structure Braun :> BRAUN = struct
end

