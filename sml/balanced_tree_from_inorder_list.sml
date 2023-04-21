datatype 'a tree = Lf | Br of 'a * 'a tree * 'a tree


exception Unbalanced
fun is_balanced t = 
  let fun bal Lf = 0
        | bal (Br (_, l ,r)) = 
            let val v1 = bal l
                val v2 = bal r
            in 
              if abs((v1-v2)) <= 1 
              then 1+v1+v2 
              else raise Unbalanced
            end
  in let val n = bal t in n=n handle Unbalanced => false end end


(* Traverse a tree inorder*)
fun inorder tree = 
  let fun aux (Lf, acc) = acc
        | aux (Br (v, l, r), acc) = aux (l, v::aux (r, acc))
  in aux (tree, []) end

fun make_lst n = if n = 0 then [] else n::(make_lst (n-1))
val test1 = is_balanced (balin [])
val test2 = is_balanced (balin (make_lst 3))
val test2a = (inorder (balin (make_lst 3))) = [3,2,1]
val test3 = is_balanced (balin (make_lst 20))
val test4 = is_balanced (balin (make_lst 100))
