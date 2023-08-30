type graph = (string * string) list

let from_list x = x

let nexts graph node =
    graph
    |> List.filter (fun (x,_) -> x=node) 
    |> List.map (fun (_,y) -> y)

let breadthf graph start = 
    let rec aux queue acc =
        match queue with
        | [] -> acc
        | x :: xs -> 
            if List.mem x acc then aux xs acc
            else aux (nexts graph x) (aux xs (x :: acc))
    in List.rev (aux [start] [])

let level_sets graph start =
    let sets = Array.make (List.length graph) [] in
    let rec aux queue seen =
        match queue with
        | [] -> sets
        | (x, i) :: xs -> 
                if List.mem x seen then aux xs seen 
                else (
                    sets.(i) <- x :: sets.(i); 
                    let children = nexts graph x in
                    let child_depths = List.map (fun c -> (c, i+1)) children in
                    aux (xs @ child_depths) (x :: seen)
                )
    in aux [(start, 0)] []

