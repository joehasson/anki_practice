fun zip (a, []) = []
  | zip ([], b) = []
  | zip (x::xs, y::ys) = (x,y)::(zip (xs, ys))

val test1 = zip([1,2,3],["a", "b", "c"]) = [(1,"a"), (2, "b"), (3, "c")]
