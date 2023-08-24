open OUnit2
open Braun_trees.BraunArray

let testval = from_list [1;2;3;4;5]

let test0 = "to_list preserves order" >:: (fun _ ->
    let result = to_list testval in
    List.iteri (fun i e -> assert_equal ~printer: string_of_int (sub testval (i+1)) e) result)

let test1a = "Sub" >:: (fun _ -> assert_equal ~printer: string_of_int 3 (sub testval 3))
let test1b = "Update" >:: (fun _ -> assert_equal  (from_list [1;2;100;4;5]) (update testval 3 100))

let test2aVal = to_list (lorem testval)
let test2a = "lorem has stuff" >:: (fun _ -> assert_equal [2;3;4;5] test2aVal)

let test2bVal = [1] |> from_list |> lorem |> to_list
let test2b = "lorem has 1" >:: (fun _ -> assert_equal [] test2bVal)

let test3aVal = to_list (loext testval 0)
let test3a = "loext has stuff" >:: (fun _ -> assert_equal [0;1;2;3;4;5] test3aVal)

let test3bVal = [] |> from_list |> fun t -> loext t 50 |> to_list
let test3b = "loext empty" >:: (fun _ -> assert_equal  [50] test3bVal)


let tests = "Test suite" >::: [test0; test1a; test1b; test2a; test2b; test3a; test3b]

let () = run_test_tt_main tests
