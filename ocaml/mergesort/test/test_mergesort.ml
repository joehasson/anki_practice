open Mergesort
open OUnit2

let rec is_sorted = function
| [] | [_] -> true
| x :: y :: xs -> x <= y && is_sorted xs 

let make_test sortfn description input =
    let output = sortfn input in
    let testfn _ = assert_bool "not sorted" (is_sorted output) in
    description >:: testfn

let test_cases = [
    "empty", [];
    "singleton", [1];
    "some nums1", [5;2;5;1;7;4;2;8];
    "some nums2", [5;2;5;1;9;7;4;2;8];
    "some nums3", [5;2;5;1;9;7;4;2;8;3;134;542;2;13;563;234;245;675;654;2;642;35;34567;542;21;2];
]

let tmergesort_tests = 
    "Top-down mergesort tests" 
    >::: List.map (fun (description, input) -> make_test tmergesort description input) test_cases

let mergesort_tests = 
    "Bottom-up mergesort tests" 
    >::: List.map (fun (description, input) -> make_test mergesort description input) test_cases

let tests = "All tests" >::: [tmergesort_tests; mergesort_tests]

let () = run_test_tt_main tests
