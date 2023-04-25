datatype 'a tree = Lf | Br of 'a * 'a tree * 'a tree

fun cartprod ([], ys) = []
  | cartprod (x::xs, ys) = 
      let
        fun withx [] = cartprod (xs, ys)
          | withx (y::ys) = (x,y)::withx ys
      in 
        withx ys 
      end

fun all_preorder [] = [Lf]
  | all_preorder (x::xs) =
      let
        fun subtree_pairs i = 
          cartprod(
          all_preorder (List.take (xs, i)), 
          all_preorder (List.drop (xs, i)))
        fun build 0 = subtree_pairs 0
          | build n = (subtree_pairs n) @ (build (n-1))
      in 
        List.map (fn (l, r) => Br (x,l,r)) (build (List.length xs)) 
      end


(* Testing Code*)
fun all_distinct [] = true
  | all_distinct (x::xs) = (List.all (fn y => x <> y) xs) andalso all_distinct xs

val test_val = all_preorder [1,2,3]
val foo = List.length test_val 
val bar = all_distinct test_val
val test1 = List.length test_val = 5
val test1a = all_distinct test_val
