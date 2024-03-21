type _ value =
| Int: int -> int value
| Bool: bool -> bool value

type _ expr =
| Value: 'a value -> 'a expr
| If: bool expr * 'a expr * 'a expr -> 'a expr
| Eq: 'a expr * 'a expr -> bool expr
| Plus: int expr * int expr -> int expr

let rec eval: type a. a expr -> a value = function
| Value v -> v
| If (be, e1, e2) -> let Bool b = eval be in if b then eval e1 else eval e2
| Eq (e1, e2) -> Bool (eval e1 = eval e2)
| Plus (e1, e2) -> let Int i, Int j = eval e1, eval e2 in Int (i+j)
