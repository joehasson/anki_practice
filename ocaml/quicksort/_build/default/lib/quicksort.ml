let partition pivot xs = 
    let rec aux xs left right = match xs with
    | [] -> left, right
    | x :: xs' ->
        if x <= pivot 
        then aux xs' (x :: left) right
        else aux xs' left (x :: right)
    in aux xs [] []

let sort lst =
    let rec quicksort unsorted sorted =
        match unsorted with
        | [] -> sorted
        | pivot :: xs ->
            let left, right = partition pivot xs in
            quicksort left (pivot :: quicksort right sorted)
    in quicksort lst []

