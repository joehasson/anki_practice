fun insert (x, []) = [x]
  | insert (x, y::ys) = if x < y then x::y::ys else y::insert(x, ys)

fun insort [] = []
  | insort (x::xs) = insert(x, insort xs)

