let quicksort list = 
    let rec aux list sorted = match list with
            | [] -> sorted
            | (x::xs) ->
                    let left, right = List.partition (fun y -> y < x) xs
                    in aux left (x :: aux right sorted)
    in aux list []

