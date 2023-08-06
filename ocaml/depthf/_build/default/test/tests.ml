open OUnit2

let graph1 = [("a","b"); ("a","c"); ("a","d");
              ("b","e"); ("c","f"); ("d","e");
              ("e","f"); ("e","g")]

let test = "Test" >:: fun _ -> 
    assert_equal 
    ~printer: (List.fold_left (fun s c -> s ^ " " ^ c) "")
    ["a";"b";"e";"f";"g";"c";"d"] 
    (Depthf.search graph1 "a")

let () = run_test_tt_main test
