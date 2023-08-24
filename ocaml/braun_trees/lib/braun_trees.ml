module type BRAUN = sig
    type t
    val empty: t
    val sub: t -> int -> int 
    val update: t -> int -> int -> t
    val delete: t -> int -> t
    val loext: t -> int -> t
    val lorem: t -> t
    val to_list: t -> int list
    val from_list: int list -> t
end

