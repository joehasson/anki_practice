let nexts graph node =
    let edges = List.filter (fun (x,_) -> x=node) graph
    in List.map snd edges

let search graph init = 
    let rec aux to_visit visited =
        match to_visit with
        | [] -> visited
        | x :: xs -> 
                if List.mem x visited
                then aux xs visited
                else aux xs (aux (nexts graph x) (x :: visited))
    in List.rev (aux [init] [])

