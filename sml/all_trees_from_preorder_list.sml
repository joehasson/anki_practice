datatype 'a tree = Lf | Br of 'a * 'a tree * 'a tree


(* Testing Code*)
fun all_distinct [] = true
  | all_distinct (x::xs) = (List.all (fn y => x <> y) xs) andalso all_distinct xs

val test_val = all_preorder [1,2,3]
val foo = List.length test_val 
val bar = all_distinct test_val
val test1 = List.length test_val = 5
val test1a = all_distinct test_val
