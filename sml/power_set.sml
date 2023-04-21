fun power_set lst = 
  let fun aux([], acc) = [acc]
        | aux(x::xs, acc) = aux(xs, x::acc) @ aux(xs, acc)
  in aux(lst, []) end

fun power_set2 lst =
  let fun aux ([], acc, res) = acc::res
        | aux (x::xs, acc, res) = aux (xs, x::acc, aux(xs, acc, res))
  in aux (lst, [], []) end


val test0 = (power_set []) = [[]]
val test0b = (power_set []) = [[]]
val test1 = List.length (power_set [1,2,3,4,5]) = 32
val test1b = List.length (power_set2 [1,2,3,4,5]) = 32
