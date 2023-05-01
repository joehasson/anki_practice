datatype prop = Atom of string | Neg of prop | Disj of prop * prop | Conj of prop * prop 

fun ifthen(p,q) = Disj(Neg p, q)

fun nnf (Atom s) = Atom s
  | nnf (Neg (Conj(p,q))) = Disj (nnf (Neg p), nnf (Neg q))
  | nnf (Neg (Disj(p,q))) = Conj (nnf (Neg p), nnf (Neg q))
  | nnf (Neg (Neg p)) = nnf p
  | nnf (Conj (p,q)) = Conj (nnf p, nnf q)
  | nnf (Disj (p,q)) = Disj (nnf p, nnf q)
  | nnf (Neg p) = Neg (nnf p)


fun distrib (p, Conj (q,r)) = Conj (distrib (p,q), distrib (p,r))
  | distrib (Conj (p,q), r) = Conj (distrib (p,r), distrib (q,r))
  | distrib (p,q) = Disj (p,q)

fun nnf_to_cnf (Disj (p,q)) = distrib (nnf_to_cnf p, nnf_to_cnf q)
  | nnf_to_cnf (Conj (p,q)) = Conj (nnf_to_cnf p, nnf_to_cnf q)
  | nnf_to_cnf p = p 


(* Test cases *)
fun to_string (Disj (Neg p, q)) = "(" ^ (to_string p) ^ " -> " ^ (to_string q) ^ ")"
  | to_string (Disj (p, Neg q)) = "(" ^ (to_string q) ^ " -> " ^ (to_string p) ^ ")"
  | to_string (Conj (p,q)) = "(" ^ (to_string p) ^ " & " ^ (to_string q) ^ ")"
  | to_string (Disj (p,q)) = "(" ^ (to_string p) ^ " V " ^ (to_string q) ^ ")"
  | to_string (Neg p) = "~" ^ (to_string p) 
  | to_string (Atom s) = s

infix !>
fun (x !> f) = f x

val test1_formula = Neg (Conj (ifthen (Neg (Atom "P"), Neg (Atom "Q")), Neg (Atom "R")))
val test1_actual = test1_formula !> nnf !> nnf_to_cnf
val test1_expected = Conj (Disj (Neg (Atom "P"), Atom "R"), Disj(Atom "Q", Atom "R"))
val _ = print ("\ntest1 nnf:\n" ^ (to_string (nnf test1_formula)))
val _ = print ("\ntest1 actual:\n" ^ (to_string test1_actual))
val _ = print ("\ntest1 expected:\n" ^ (to_string test1_expected))
val _ = print "\n"

val test2_formula = ifthen (ifthen (Atom "P", Atom "Q"), Conj (Neg (Atom "R"), Atom "Q")) 
val test2_actual = test2_formula !> nnf !> nnf_to_cnf
val test2_expected = 
  Conj(
    Disj (Atom "P", Neg (Atom "R")), 
  Conj(
  Conj( 
    Disj(Atom "P", Atom "Q"), 
    Disj (Neg (Atom "Q"), Neg (Atom "R"))),
    Disj (Atom "Q", Neg (Atom "Q"))
  ))
val _ = print ("\ntest2 nnf:\n" ^ (to_string (nnf test2_formula)))
val _ = print ("\ntest2 actual:\n" ^ (to_string test2_actual))
val _ = print ("\ntest2 expected:\n" ^ (to_string test2_expected))
val _ = print "\n"
