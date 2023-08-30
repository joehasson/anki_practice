open Breadthf
open OUnit2

let example = Graph.from_list [
    ("a","b"); ("a","c"); ("a","d"); ("b","e"); 
    ("c","f"); ("d","e");("e","f");("e","g");
]

let string_of_string_list = List.fold_left (fun acc s -> acc ^ " " ^ s) ""

let sort_strings = List.sort String.compare 

let tests = "tests" >::: [
    "ML For the Working Programmer example" >:: (fun _ ->
        assert_equal 
            ["a"; "b"; "c"; "d"; "e"; "f"; "g"]
            (Graph.breadthf example "a")
            ~printer: string_of_string_list
    );
    "Level sets version" >:: (fun _ -> 
        let sets = Graph.level_sets example "a" in
        Array.iteri (fun i set ->
            let expected =
                if i = 0 then ["a"]
                else if i = 1 then ["b";"c";"d"]
                else if i = 2 then ["e"; "f"]
                else if i = 3 then ["g"]
                else []
            in assert_equal expected (sort_strings set)) sets
    )
]

let () = run_test_tt_main tests 

