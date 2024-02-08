open Balanced_tree_from_inorder_list
open OUnit2

let rec is_balanced = 
    let rec size = function
        | Lf -> 0
        | Br (_,t1,t2) -> 1 + size t1 + size t2
    in
    function
    | Lf -> true
    | Br (_,t1,t2) -> 
            is_balanced t1 && 
            is_balanced t2 && 
            Int.abs (size t1 - size t2) <= 1


let make_test label list = 
    label >:: fun _ -> 
        assert_bool "not balanced" (is_balanced (convert list))


let tests = "test_suite" >::: [
    make_test "Empty" [];
    make_test "Singleton" [1];
    make_test "Even number" [1;2;3;4;5;6;7;8];
    make_test "Odd number" [1;2;3;4;5;6;7;8;9];
]

let () = run_test_tt_main tests
