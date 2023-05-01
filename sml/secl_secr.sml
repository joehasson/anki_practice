(* Implementation *)

fun secl x f y = f (x, y)
fun secr f y x = f (x, y)

(* Test cases *)
fun inter ([], ys) = []
  | inter (x::xs, ys) = 
      case List.find (fn y => x=y) ys of 
           SOME _ => x::inter(xs,ys) 
         | NONE => inter (xs, ys)

val test1_func = secr op@ ["Richard"]
val test1 = (test1_func ["Hey", "There"]) = ["Hey", "There", "Richard"]

val test2_func = secl ["heed", "of", "Yonder", "dog"] List.take
val test2 =  (test2_func 3) = ["heed", "of", "Yonder"]

fun test3_func x = (secr List.take 3) x (* value restriction *)
val test3 = (test3_func ["heed", "of", "Yonder", "cat"]) = ["heed", "of", "Yonder"] 


val test4_func = secl ["his", "venom", "tooth"] inter
val test4 = (test4_func ["her", "venom"]) = ["venom"]
