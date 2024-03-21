module OrderedStr = struct
    type t = string
    let compare = String.compare
end

module AdjacencyMap = Map.Make(OrderedStr)
module StrSet = Set.Make(OrderedStr)

type graph = string list AdjacencyMap.t

let from_list list = 
    let res = List.fold_left 
        (fun m (k,v) -> 
            match AdjacencyMap.find_opt k m with
            | None -> AdjacencyMap.add k [v] m
            | Some list -> AdjacencyMap.add k (v :: list) m
        )
        AdjacencyMap.empty
        list
    in res

let nexts u g = match AdjacencyMap.find_opt u g with
| None -> []
| Some list -> list

let breadthf graph s =
    let q = Queue.create () in
    let () = Queue.add s q in
    let rec aux seen result =
        match Queue.take_opt q with
        | None -> result
        | Some u -> 
                if StrSet.mem u seen 
                then aux seen result
                else 
                    let () = List.iter (fun u -> Queue.push u q) (nexts u graph) in
                    aux (StrSet.add u seen) (u :: result)
    in List.rev (aux StrSet.empty [])

let level_sets (graph: graph) (s: string) : string list array =
    let q = Queue.create () in
    let arr = Array.init (AdjacencyMap.cardinal graph + 1) (fun _ -> []) in
    let () = Queue.add (s,0) q in
    let rec aux seen =
        match Queue.take_opt q with
        | None -> ()
        | Some (u, i) -> 
                if StrSet.mem u seen 
                then aux seen 
                else 
                    let () = arr.(i) <- u :: arr.(i) in
                    let () = List.iter (fun u -> Queue.push (u,i+1) q) (nexts u graph) in
                    aux (StrSet.add u seen)
    in 
    let () = aux StrSet.empty in
    arr

