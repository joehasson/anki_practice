open OUnit2

let string_of_list lst =
    "[" ^ (
        List.fold_right 
            (fun i s -> string_of_int i ^ ", " ^ s)
            lst
            ""
    ) ^ "]"

let make_test expected real = 
    fun _ -> assert_equal ~printer:string_of_list expected real

let tests = "Quicksort tests" >::: [
    "Empty" >:: make_test [] (Quicksort.sort []);
    "Singleton" >:: make_test [2] (Quicksort.sort [2]);
    "Odd" >:: make_test [2; 2; 3; 4; 5; 5; 9] (Quicksort.sort [2; 5; 3; 4; 5; 2; 9]);
    "Even" >:: make_test [2; 2; 3; 4; 5; 5; 6; 9] (Quicksort.sort [2; 5; 3; 4; 5; 2; 9; 6]);
]

let () = run_test_tt_main tests
