open OUnit2
open Nqueens

let count_solns dimension =  
    Seq.length (solve dimension)

let maketest expected actual =
    assert_equal expected actual ~printer:Int.to_string

let tests = "test suite for nqueens" >:::  [
    "3 queens" >:: (fun _ -> maketest 0 (count_solns 3));
    "4 queens" >:: (fun _ -> maketest 2 (count_solns 4));
    "8 queens" >:: (fun _ -> maketest 92 (count_solns 8));
]

let _ = run_test_tt_main tests

