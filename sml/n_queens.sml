datatype 'a seq = Nil | Cons of ('a * (unit -> 'a seq))

infix mem

fun (x mem []) = false
  | (x mem (y::ys)) = x=y orelse x mem ys

fun nexts num_cols oldqs =
  let 
    fun hasdiagonal n qs =
      let 
        fun aux n [] _ = false
            | aux n (q::qs) dist = Int.abs(n-q) = dist orelse aux n qs (dist+1)
      in 
        aux n qs 1 
      end
    fun aux 0 = []
      | aux n = if n mem oldqs orelse hasdiagonal n oldqs 
                then aux (n-1) else (n::oldqs)::aux (n-1) 
  in
    aux num_cols
  end

val test = nexts 8 [1,4,2]

fun bfs nexts init =
  let 
    fun aux [] = Nil
      | aux (n::ns) = Cons (n, fn () => aux (ns @ nexts n))
  in aux [init] end
          
fun dfs nexts init =
  let 
    fun aux [] = Nil
      | aux (n::ns) = Cons (n, fn () => aux (nexts n @ ns))
  in aux [init] end


(* Test cases *)

fun seq_to_list Nil = []
  | seq_to_list (Cons (x, f)) = x :: seq_to_list (f())

val queens_soln8_bfs = List.filter (fn l => List.length l = 8) (seq_to_list (bfs (nexts 8) []))
val queens_soln8_dfs = List.filter (fn l => List.length l = 8) (seq_to_list (dfs (nexts 8) []))

val right_number_bfs = List.length queens_soln8_bfs = 92
val right_number_dfs = List.length queens_soln8_dfs = 92

