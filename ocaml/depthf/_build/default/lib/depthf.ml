let nexts graph v =
    let edges = List.filter (fun (u,_) -> v=u) graph
    in List.map (fun (_,u) -> u) edges

let search graph init =
    let rec aux stack visited = match stack with
    | [] -> visited
    | x :: xs -> if List.mem x visited then aux xs visited
                 else aux xs (aux (nexts graph x) (x :: visited))
    in List.rev (aux [init] [])
