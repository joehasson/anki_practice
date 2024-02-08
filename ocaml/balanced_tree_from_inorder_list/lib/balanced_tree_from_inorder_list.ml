type 'a t = 
    | Lf 
    | Br of 'a * 'a t * 'a t

let rec convert list =
    let rec split = function
        | [] -> [], None, []
        | x :: xs ->
                match split xs with
                | [], None, [] -> [], Some x, [] 
                | _, None, _ -> assert false
                | last :: left, Some y, right ->
                        x :: left, Some last, y :: right
    in
    match list with
    | [] -> Lf
    | x :: xs -> 
        let left, Some root, right = split (x :: xs)
        in Br (root, convert left, convert right)

