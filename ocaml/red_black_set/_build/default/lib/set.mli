(**A set*)
type t

(** The empty set *)
val empty: t

val insert: t -> int -> t

val to_list: t -> int list

val from_list: int list -> t

val size: t -> int

val mem: t -> int -> bool
 
