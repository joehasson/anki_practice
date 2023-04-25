fun nexts (a, []) = []
  | nexts (a, (x,y)::g) = if a=x then y::nexts (a, g) else nexts (a, g)

infix mem
fun (x mem []) = false
  | (x mem (y::ys)) = x=y orelse x mem ys


fun breadthf (start, graph) = 
  let fun aux ([], visited, acc) = acc
        | aux (x::queue, visited, acc) =
            if x mem visited then aux (queue, visited, acc)
            else aux (queue @ nexts(x, graph), x::visited, x::acc)
  in List.rev (aux ([start], [], [])) end

val graph1 = [("a","b"), ("a","c"), ("a","d"),
              ("b","e"), ("c","f"), ("d","e"),
              ("e","f"), ("e","g")]

val foo = breadthf("a", graph1) 
val test1 = breadthf("a", graph1) = ["a","b","c","d","e","f","g"]
