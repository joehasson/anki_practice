open OUnit2
open Tree_traversal

let example = Br (1, 
                  Br (2, 
                      Lf, 
                      Br (3,Lf, Lf)),
                  Br (4, 
                      Br(5, Lf, Lf), 
                      Br(6, Lf, Br(7, Lf, Lf))))


module MakeTests (Impl: Traversals) = struct
    let make_test_fun ref imp = fun _ ->
        assert_equal (ref example) (imp example)

    let test_suite = [ 
        "preorder" >:: (make_test_fun Reference.RefImpl.preorder Impl.preorder);
        "inorder" >:: (make_test_fun Reference.RefImpl.inorder Impl.inorder);
        "postorder" >:: (make_test_fun Reference.RefImpl.postorder Impl.postorder);
    ]
end

module Impl1Tests = MakeTests(Impl1)
module Impl2Tests = MakeTests(Impl2)
let tests = "All tests" >::: (Impl1Tests.test_suite @ Impl2Tests.test_suite)

let () = run_test_tt_main tests

