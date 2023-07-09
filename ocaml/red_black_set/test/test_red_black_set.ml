open OUnit2

module Rb = Red_black_set.Set 

let rec sym_diff xs ys = match xs, ys with
  | [], _ -> []
  | x :: xs, ys -> if List.mem x ys then sym_diff xs ys else x :: sym_diff xs ys

let test_set_singleton = (Rb.insert Rb.empty 1)
let test_set_mult = Rb.from_list [1;2;3;4;5;6;7;8;9]

let to_list_tests = "to_list tests" >::: [
    "empty" >:: (fun  _ -> assert_equal [] (Rb.to_list Rb.empty));
    "singleton" >:: (fun _ ->
        assert_equal [1] (Rb.to_list test_set_singleton)
    );
    "A few" >:: (fun _ -> 
        let l = [1;2;3;4;5;6;7;8;9] in 
        assert_bool "to_list didn't yield all the right elements"
            (sym_diff l (Rb.to_list test_set_mult) = [])
    )
    ]

let () = run_test_tt_main to_list_tests

