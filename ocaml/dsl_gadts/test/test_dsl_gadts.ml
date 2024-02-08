open OUnit2
open Dsl_gadts.Lang

let eval_vals = 
    "eval of values" >::: [
        "int" >:: (fun _-> assert_equal (Int 20) (eval (Value (Int 20))));
        "bool" >:: (fun _-> assert_equal (Bool true) (eval (Value (Bool true))));
    ]

let eval_plus =
    let one = Value (Int 1) in
    let ten = Value (Int 10) in
    let twenty = Value (Int 20) in
    let tenplustwenty = Plus (ten, twenty) in
    "plus expressions" >::: [
        "10 + 20 = 30" >:: (fun _ -> assert_equal (Int 30) (eval tenplustwenty));
        "10 + 20 + 1 = 31" >:: (fun _ -> assert_equal (Int 31) (eval (Plus(one, tenplustwenty))))
    ]

let eval_bool =
    let truth = Value (Bool true) in
    let falsehood = Value (Bool false) in
    let ten = Value (Int 10) in
    let twenty = Value (Int 20) in
    "if expressions" >::: [
        "if true then 10 else 20 = 10" >:: (fun _ -> 
            let ifexp = If (truth, ten, twenty) in
            assert_equal (Int 10) (eval ifexp));
        "if false then 10 else 20 = 20" >:: (fun _ -> 
            let ifexp = If (falsehood, ten, twenty) in
            assert_equal (Int 20) (eval ifexp))
    ]

let tests = "test suite" >:::  [
    eval_vals;
    eval_plus;
    eval_bool
]

let _ = run_test_tt_main tests

