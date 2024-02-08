module type Map = sig
    type key
    type 'a t
    val insert: 'a t -> key -> 'a -> unit
    val find: 'a t -> key -> 'a option
    val remove: 'a t -> key -> unit
    val create: int -> 'a t
end

module type Key = sig
    type t
    val hash: t -> int
end

module MakeMap (Key: Key) = struct
    type key = Key.t

    type 'a t = {
        mutable buckets: (key * 'a) list array;
        mutable size: int;
    }

    let bucket_index tab k =
        let buckets = Array.length tab.buckets in
        tab.hash k mod buckets

    let insert tab k v =
        let i = bucket_index tab k in
        if not (List.mem_assoc k tab.buckets.(i)) then tab.size <- tab.size + 1;
        tab.buckets.(i) = (k,v) :: List.remove_assoc k tab.buckets.(i);
        resize_if_needed tab
        

end
