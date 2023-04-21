fun merge ([], ys) = ys
  | merge (xs, []) = xs
  | merge (x::xs, y::ys) = if x <= y then x::merge(xs, y::ys) else y::merge(x::xs, ys)



fun mergepairs (l1::l2::lst, i) =
      if i mod 2 = 1 then l1::l2::lst
      else mergepairs (merge(l1,l2)::lst, i div 2)
  | mergepairs (lst, i) = lst

fun mergesort lst =
  let fun aux ([], acc, _) = hd (mergepairs (acc, 0))
        | aux (x::xs, acc, i) = aux (xs, mergepairs ([x]::acc, i+1), i+1)
  in aux (lst, [[]], 0) end

val test1 = mergesort ([5,2,1,4,3]) = [1,2,3,4,5]
val test2 = mergesort ([1,3,4,3,3,5,3,2,10,1]) = [1,1,2,3,3,3,3,4,5,10]
