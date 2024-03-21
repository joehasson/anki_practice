(*
Imagine the set of all possible strings over this alphabet as a trie
                      ""
                /      |    \
             A         B      C
         /   |  \     ...    ...
        AA  AB   AC
       /|\  /|\  /|\
        ...  ... ...
This trie can be computed lazily: suppose we have a function parent -> child[].
To enumerate all strings we can perform a lazy bfs over this trie. Then just
filter for the palindromes.
*)
type alphabet = char list
type word = char list

let children (alphabet: alphabet) (parent: word) : word list =
    List.map (fun ch -> ch :: parent) alphabet

let bfs (child_fn: word -> word list) (root: word) : word Seq.t = 
    let q = Queue.create () in
    let () = Queue.add root q in
    let rec aux () =
        let next = Queue.take q in
        Queue.add_seq q (child_fn next |> List.to_seq);
        Seq.Cons (next, aux)
    in aux

let is_palindrome word = 
    List.rev word = word

let palindromes (alphabet: alphabet) : word Seq.t =
    Seq.filter is_palindrome (bfs (children alphabet) [])

