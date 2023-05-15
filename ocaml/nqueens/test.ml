open OUnit2
open Nqueens

let count_solns dimension = 
    let rec aux acc = function
        | Nil -> acc
        | Cons(_,xf) -> aux (1+acc) (xf ())
    in aux 0 (nqueens dimension)


let tests = "test suite for nqueens" >:::  [
    "3 queens" >:: (fun _ -> assert_equal 0 (count_solns 3));
    "4 queens" >:: (fun _ -> assert_equal 2 (count_solns 4));
    "8 queens" >:: (fun _ -> assert_equal 92 (count_solns 8));
]

let _ = run_test_tt_main tests

