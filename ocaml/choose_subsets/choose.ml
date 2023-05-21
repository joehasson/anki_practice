let choose lst n = 
    let rec aux lst n acc res = match lst,n,acc,res with
            | _,0,acc,res -> acc::res
            | [],i,acc,res -> res 
            | x::xs,i,acc,res -> aux xs (i-1) (x::acc) (aux xs i acc res)
    in aux lst n [] []

