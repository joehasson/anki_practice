module OrderedString = struct
    type t = string
    let compare = String.compare
end

module StringMap = Map.Make(OrderedString)
module StringSet = Set.Make(OrderedString)

(* Adjacency list implementation *)
type graph = string list StringMap.t

let nexts u graph = 
    match StringMap.find_opt u graph with
    | None -> []
    | Some vs -> vs

let rec from_list = function
| [] -> StringMap.empty
| (k,v) :: xs -> 
        let rest = (from_list xs) in
        match StringMap.find_opt k rest with
        | None -> StringMap.add k [v] rest
        | Some vs -> StringMap.add k (v::vs) rest

let breadthf graph src =
    let q = Queue.create () in
    let () = Queue.add src q in
    let rec aux seen acc =
        match Queue.take_opt q with
        | None -> acc
        | Some u ->
            if StringSet.mem u seen
            then aux seen acc
            else 
                let vs = nexts u graph in
                let () = List.iter (fun v -> Queue.add v q) vs in
                aux (StringSet.add u seen) (u :: acc)
    in List.rev (aux StringSet.empty [])

let level_sets graph src =
    let maxdepth = StringMap.cardinal graph in
    let levels = Array.init maxdepth (fun _ -> []) in
    let q = Queue.create () in
    let () = Queue.add (src,0) q in
    let rec aux seen =
        match Queue.take_opt q with
        | None -> ()
        | Some (u,i) ->
            if StringSet.mem u seen
            then aux seen 
            else 
                let vs = nexts u graph in
                List.iter (fun v -> Queue.add (v, i+1) q) vs;
            levels.(i) <- u :: levels.(i);
            aux (StringSet.add u seen)
    in aux StringSet.empty; levels


