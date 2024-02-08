let rec quickselect lst i = 
    match lst, i with
    | [], _ -> failwith "Out of bounds"
    | (x::xs), i ->
        let lesser, greater = List.partition (fun e -> e <= x) xs in
        let len = List.length lesser in
        if i < len then quickselect lesser i
        else if i = len then x
        else quickselect greater (i - len - 1)


let test1 = quickselect [1;2;3;4;5] 0
let test2 = quickselect [1;2;3;4;5] 3
let test3 = quickselect [1;2;3;4;5] 4

