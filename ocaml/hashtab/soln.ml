module type Map = sig
    type ('k, 'v) t
    val insert: 'k -> 'v -> ('k, 'v) t -> unit
    val find: 'k -> ('k, 'v) t -> 'v option
    val remove: 'k -> ('k, 'v) t -> unit 
    val create: ('k -> int) -> int -> ('k, 'v) t
end


module HashTable : Map = struct
    type ('k, 'v) t = {
        hash: 'k -> int;
        mutable buckets: ('k * 'v) list array;
        mutable size: int;
    }

    let create hash capacity = {
        hash = hash;
        buckets = Array.make capacity [];
        size = 0;
    }

    let resize_threshold = 2.


    let capacity tab = Array.length tab.buckets


    let insert_no_resize k v tab =
        let b = tab.hash k mod capacity tab in
        if List.mem_assoc k tab.buckets.(b) 
        then tab.buckets.(b) <- List.remove_assoc k tab.buckets.(b)
        else tab.size <- tab.size + 1
        ; tab.buckets.(b) <- (k, v) :: tab.buckets.(b)


    let remove_no_resize k tab =
        let b = tab.hash k mod capacity tab in
        if List.mem_assoc k tab.buckets.(b)
        then (tab.buckets.(b) <- List.remove_assoc k tab.buckets.(b)
        ; tab.size <- tab.size - 1)
        else failwith "Not in the map"


    let resize_if_needed tab = 
        let 
          rehash tab new_capacity =
            let rehash_binding (k,v) = insert_no_resize k v tab in
            let rehash_bucket = List.iter rehash_binding in
            let old_buckets = tab.buckets in
            tab.buckets <- Array.make new_capacity []
            ; Array.iter rehash_bucket old_buckets 
        in
        let bucket_count = capacity tab in
        let load_factor = float_of_int tab.size /. float_of_int bucket_count in
        if load_factor >= resize_threshold
        then rehash tab (bucket_count * 2)
        else if load_factor <= 1. /. resize_threshold
        then rehash tab (bucket_count / 2)


    let insert k v tab =
        insert_no_resize k v tab;
        resize_if_needed tab

    let remove k tab =
        remove_no_resize k tab;
        resize_if_needed tab

    let find k tab =
        let bucket = tab.buckets.(tab.hash k mod capacity tab) in
        List.assoc_opt k bucket
end
