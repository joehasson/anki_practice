fun merge (x::xs, y::ys) = if x <= y then x::merge(xs, y::ys) else y::merge(x::xs, ys)
  | merge (xs, []) = xs
  | merge ([], ys) = ys

fun mergepairs (x::y::l, k) =
      if k mod 2 = 1 then x::y::l
      else mergepairs(merge(x,y)::l, k div 2)
  | mergepairs ([x], k) = [x]

fun mergesort lst =
  let fun aux ([], l, k) = hd (mergepairs (l, 0))
        | aux (x::xs, l, k) = aux (xs, mergepairs ([x]::l, k+1), k+1)
  in aux (lst, [[]], 0) end

val test1 = mergesort ([5,2,1,4,3]) = [1,2,3,4,5]
val test2 = mergesort ([1,3,4,3,3,5,3,2,10,1]) = [1,1,2,3,3,3,3,4,5,10]
