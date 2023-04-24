fun merge ([], ys) = ys
  | merge (xs, []) = xs
  | merge (x::xs, y::ys) = if x <= y then x::merge (xs, y::ys) else y::merge (x::xs, ys)

fun mergesort [] = []
  | mergesort [x] = [x]
  | mergesort xs = 
  let
    val len = List.length xs
    val left = List.take (xs, len div 2)
    val right = List.drop (xs, len div 2)
  in
    merge (mergesort left, mergesort right)
  end

val test1 = mergesort ([5,2,1,4,3]) = [1,2,3,4,5]
val test2 = mergesort ([1,3,4,3,3,5,3,2,10,1]) = [1,1,2,3,3,3,3,4,5,10]
