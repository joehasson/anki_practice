datatype 'a seq = Nil | Cons of 'a * (unit -> 'a seq)

fun bfs nexts x =
  let 
    fun aux (q::qs) = Cons (q, fn () => aux (qs @ (nexts q)))
      | aux [] = Nil
  in 
    aux [x] 
  end

fun children (a::alphabet) chars = (a::chars) :: (children alphabet chars)
  | children [] node = []


fun all_palindromes alphabet = bfs (children alphabet) []

(* Test cases *)

fun seq_take (0, _) = []
  | seq_take (n, Nil) = raise Size
  | seq_take (n, Cons(x,f)) = x :: seq_take(n-1, f())

fun seq_map f Nil = Nil
  | seq_map f (Cons(x,g)) = Cons(f x, fn () => seq_map f (g()))

val test_val1 = 
  let
    val pals = seq_map String.implode (all_palindromes [#"A", #"B", #"C"])
  in 
    seq_take (10, pals)
  end

val test_val2 = 
  let
    val pals = seq_map String.implode (all_palindromes [#"X", #"Q"])
  in 
    seq_take (10, pals)
  end

