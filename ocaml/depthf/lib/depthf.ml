let rec nexts graph v =
    match graph with
    | [] -> []
    | (x,y)::graph' -> if x=v then y :: nexts graph' v else nexts graph' v

let depthf graph init =
    let rec aux toVisit visited = 
        match toVisit, visited with
        | [], visited -> visited
        | x::xs, visited -> if List.mem x visited 
                            then aux xs visited 
                            else aux xs (aux (nexts graph x) (x::visited))
    in List.rev (aux [init] [])

let graph1 = [("a","b"); ("a","c"); ("a","d");
              ("b","e"); ("c","f"); ("d","e");
              ("e","f"); ("e","g")]

let test1 = depthf graph1 "a" = ["a";"b";"e";"f";"g";"c";"d"]
