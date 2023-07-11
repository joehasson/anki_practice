open Breadthf
open OUnit2

let tests = "tests" >::: [
    "ML For the Working Programmer example" >:: (fun _ ->
        assert_equal 
            ["a"; "b"; "c"; "d"; "e"; "f"; "g"]
            (
                Graph.breadthf (
                    Graph.from_list [
                        ("a","b"); ("a","c"); ("a","d"); ("b","e"); 
                        ("c","f"); ("d","e");("e","f");("e","g");]) 
                "a"
            )
            ~printer: (List.fold_left (fun acc s -> acc ^ " " ^ s) "")
    )
]

let () = run_test_tt_main tests 

