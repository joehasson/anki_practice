(* Would implement this as a functor if wanted other
   kinds of elements *)
type graph
val from_list: (string * string) list -> graph
val breadthf: graph -> string -> string list
val level_sets: graph -> string -> string list array
