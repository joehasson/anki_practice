open OUnit2
open All_trees_from_preorder_list


let tests = "test suite for all_trees" >:::  [
    "empty list" >:: (fun _ -> assert_equal 
                                1 
                                (List.length (all_trees []))
                                ~printer:string_of_int
    );
    "three elements" >:: (fun _ -> assert_equal 
                                    5 
                                    (List.length (all_trees [1;2;3]))
                                    ~printer:string_of_int
    );
    "six elements" >:: (fun _ -> assert_equal 
                                    132 
                                    (List.length(all_trees [1;2;3;4;5;6]))
                                    ~printer:string_of_int
    );
]

let _ = run_test_tt_main tests
