fun choose (n, s) =
  let fun aux (0, s, acc) = [acc]
        | aux (n, [], acc) = []
        | aux (n, x::xs, acc) = aux (n - 1, xs, x::acc) @ aux (n, xs, acc)
  in aux (n, s, []) end

fun chooseIter (n, s) =
  let fun aux (0, s, acc, res) = acc::res
        | aux (n, [], acc, res) = res
        | aux (n, x::xs, acc, res) =
            aux (n-1, xs, x::acc, aux (n, xs, acc, res))
  in aux (n, s, [], []) end
        
