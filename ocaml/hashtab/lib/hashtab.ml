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

    let create hashf buckets =
        {
            hash = hashf;
            buckets = Array.make buckets [];
            size = 0;
        }

    let locate k tab =
        tab.hash k mod Array.length tab.buckets

    let insert_no_resize k v tab =
        let b = locate k tab in
        let old = tab.buckets.(b) in
        if not (List.mem_assoc k old) 
            then tab.size <- tab.size + 1;
        tab.buckets.(b) <- (k,v) :: List.remove_assoc k tab.buckets.(b)

    let resize_if_needed tab =
        let bindings = float_of_int tab.size in
        let buckets = float_of_int (Array.length tab.buckets) in
        let load_factor = bindings /. buckets in
        if load_factor >= 2.0 then
            let rehash_bucket = List.iter (fun (k,v) -> insert_no_resize k v tab) in
            let old_buckets = tab.buckets in
            let new_buckets = Array.make (Array.length tab.buckets * 2) [] in
            tab.buckets <- new_buckets;
            Array.iter rehash_bucket old_buckets

    let insert k v tab =
        insert_no_resize k v tab;
        resize_if_needed tab

    let find k tab =
        let bucket = tab.buckets.(locate k tab) in
        List.assoc_opt k bucket

end
