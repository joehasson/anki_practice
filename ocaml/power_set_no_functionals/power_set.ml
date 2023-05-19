let power_set lst = 
  let rec aux lst acc res = match lst, acc, res with
    | [], acc, res -> acc::res
    | x::xs, acc, res -> aux xs (x::acc) (aux xs acc res)
  in aux lst [] []

let foo = List.length (power_set [1;2;3;4;5]) 

            
