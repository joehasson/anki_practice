let nexts graph v =
    let edges = List.filter (fun (u,_) -> v=u) graph
    in List.map (fun (_,u) -> u) edges

let search g s =
    let rec aux stack seen = match stack with
    | [] -> seen
    | u::us -> 
        if List.mem u seen
        then aux us seen
        else aux (nexts g u @ stack) (u::seen)
    in List.rev (aux [s] [])
