open Jsonparser.Solution
open OUnit2

let _assert_ok = function
| Ok _ -> ()
| Error _ -> failwith ""

let test_empty_object = "empty object" >:: (fun _ ->
    let source = "{ } " in
    let input = Input.of_string source in
    let result, _ = run json_parser input in
    assert_equal result (Ok (JsonObject StringMap.empty))
)

let tests = "tests" >::: [
    test_empty_object;
]

let () = run_test_tt_main tests
