open OUnit2
open Red_black_set

let test_set_singleton = (Set.insert Set.empty 1)
let test_set_mult = Set.from_list [1;2;3;4;5;6;7;8;9]

let to_list_tests = "to_list tests" >::: [
    "empty" >:: (fun  _ -> assert_equal [] (Set.to_list Set.empty));
    "singleton" >:: (fun _ ->
         assert_equal [1] (Set.to_list test_set_singleton)
    );
    "A few" >:: (fun _ -> List.iter print_int (Set.to_list test_set_mult))
    ]


let () = run_test_tt_main to_list_tests
