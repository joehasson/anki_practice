module type Map = sig
    type ('k, 'v) t
    val insert: 'k -> 'v -> ('k, 'v) t -> unit
    val find: 'k -> ('k, 'v) t -> 'v option
    val remove: 'k -> ('k, 'v) t -> unit 
    val create: ('k -> int) -> int -> ('k, 'v) t
end


module HashTable = struct
    type ('k, 'v) t = {
        hash: 'k -> int;
        mutable buckets: ('k * 'v) list array;
        mutable size: int
    }

    let locate k tab =
        tab.hash k mod Array.length tab.buckets

    let insert_no_resize k v tab =
        let b = locate k tab in
        let old = tab.buckets.(b) in
        if not (List.mem_assoc k old) 
            then tab.size <- tab.size + 1;
        tab.buckets.(b) <- (k,v) :: List.remove_assoc k tab.buckets.(b)


    let insert k v tab =
        insert_no_resize k v tab

end
