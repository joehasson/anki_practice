fun K x y = x
fun S f g x = (f x) (g x)

fun identity x = S K K 17

val test1 = identity 17

(*
 * Working through the steps:
 * S K K 17
 * S K K => (K x) (K x)
 * Thus you are applying a constant function which always
 * yields x to another value (happens to be the same fn).
 *)
