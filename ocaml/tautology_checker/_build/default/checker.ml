type prop =
    | Atom of string
    | Neg of prop
    | Disj of prop * prop
    | Conj of prop * prop

let ifthen p q = Disj (Neg p, q)

(** Transform an arbitrary proposition to NNF*)
let rec to_nnf = function
    | Neg (Neg p) -> to_nnf p
    | Neg (Disj (p,q)) -> Conj (to_nnf (Neg p), to_nnf (Neg q))
    | Neg (Conj (p,q)) -> Disj (to_nnf (Neg p), to_nnf (Neg q))
    | Neg p -> Neg (to_nnf p)
    | Disj (p,q) -> Disj (to_nnf p, to_nnf q)
    | Conj (p,q) -> Conj (to_nnf p, to_nnf q)
    | Atom s -> Atom s

let rec distrib p q = 
    match p, q with
    | p, Conj (q,r) -> Conj (distrib p q, distrib p r)
    | Conj(p,q), r -> Conj (distrib p r, distrib q r)
    | p,q -> Disj (p,q)

(** Transform an NNF formula to CNF *)
let rec to_cnf = function
    | Disj (p, q) -> distrib (to_cnf p) (to_cnf q)
    | Conj (p, q) -> Conj (to_cnf p, to_cnf q)
    | Neg (Atom s) -> Neg (Atom s)
    | Atom s -> Atom s
    | _ -> failwith "Argument not in NNF"


(** Gather all the conjuncts in a CNF formula *)
let rec conjuncts = function
    | Conj (p,q) -> conjuncts p @ conjuncts q
    | p -> [p]

let rec split_atoms = function
    | Conj _ -> failwith "Expected a conjunct"
    | Disj (p, q) -> 
        let positivesp, negativesp = split_atoms p in
        let positivesq, negativesq = split_atoms q in
        positivesp @ positivesq, negativesp @ negativesq
    | Neg (Atom s) -> [], [Atom s]
    | Atom s -> [Atom s], []
    | _ -> failwith "Not CNF"

let is_tautology p =
    let rec inter ps qs = 
        match ps,qs with
        | [], _ -> []
        | p::ps, qs -> if List.mem p qs then p :: inter ps qs else inter ps qs
    in
    let conjuncts = p |> to_nnf |> to_cnf |> conjuncts in
    let conjunct_is_taut p =
        let positives, negatives = split_atoms p in
        inter positives negatives <> []
    in List.fold_left (fun acc p -> acc && conjunct_is_taut p) true conjuncts
        
