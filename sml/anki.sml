fun allChangeIter (amount, coins) = 
  let fun aux (0, coinsAcc, coins, res) = coinsAcc::res
      | aux (amount, coinsAcc, [], res) = res
      | aux (amount, coinsAcc, c::coins, res) = 
          if amount < 0 
          then res
          else aux(amount-c, c::coinsAcc, c::coins, aux(amount, coinsAcc, coins, res))
  in aux (amount, [], coins, []) end

val foo = allChangeIter (16, [50, 20, 10, 5, 2 ,1])

fun nexts (node, []) = []
  | nexts (node, x::xs) = if x=node then x::(nexts (node, xs)) else nexts (node, xs)

infix mem;
fun (x mem []) = false
  | (x mem (y::ys)) = x=y orelse (x mem ys)

fun bfs (start, graph) =
  let fun aux ([], visited) = visited
        | aux (x::toVisit, visited) = if x mem visited then aux(toVisit, visited)
                                                       else aux (toVisit @ nexts(x, graph), x::visited) 
  in aux ([start], graph) end

fun quicksort [] = []
  | quicksort (p::lst) = 
  let fun aux (left, right, []) =
            (quicksort left) @ (p::(quicksort right))
        | aux (left, right, y::ys) = 
            if y < p then aux (y::left, right, ys) else aux (left, y::right, ys)
  in aux ([], [], lst) end
