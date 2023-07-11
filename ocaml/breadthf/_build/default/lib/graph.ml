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

