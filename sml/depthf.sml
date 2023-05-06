fun nexts (a, []) = []
  | nexts (a, (x,y)::g) = if a=x then y::nexts (a, g) else nexts (a, g)


infix mem
fun (x mem []) = false
  | (x mem (y::ys)) = x=y orelse x mem ys


fun depthf (start, graph) =
  let fun aux ([], acc) = acc
        | aux (x::xs, acc) =
            if x mem acc then aux (xs, acc)
            else aux (xs, aux(nexts(x, graph), x::acc))
  in List.rev (aux ([start], [])) end


val graph1 = [("a","b"), ("a","c"), ("a","d"),
              ("b","e"), ("c","f"), ("d","e"),
              ("e","f"), ("e","g")]

val test1 = depthf("a", graph1) = ["a","b","e","f","g","c","d"]
