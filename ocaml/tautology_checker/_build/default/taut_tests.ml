open Checker
open OUnit2

let positive_test p =
    fun _ -> assert_bool "Tautology not recognised as such" (is_tautology p)

let negative_test p =
    fun _ -> assert_bool "Non-tautology deemed valid" (not (is_tautology p))

let p = Atom "p"
let q = Atom "q"
let bot = Conj (p, Neg p)

(**Equivalence*)
let (---) p q = Conj (ifthen p q, ifthen q p)

let tests = "Tests for is_tautology" >::: [
    "p1" >:: positive_test (Disj(p, ifthen p q));
    "p2 Conj elim 1" >:: positive_test (ifthen (Conj (p,q)) p);
    "p2: Conj elim 2" >:: positive_test (ifthen (Conj (p,q)) q);
    "p3: Reductio" >:: positive_test (ifthen p q --- ifthen (Conj (p, Neg q)) bot);
    "n1: An atom" >:: negative_test (Atom "p");
    "n2: Affirming the consequent" >:: negative_test (ifthen (Conj (q, (ifthen p q))) p);
    "n3: Denying the antecedent" >:: negative_test (ifthen (Conj (Neg p, (ifthen p q))) (Neg q));
]

let () = run_test_tt_main tests
