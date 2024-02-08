type _ value =
    | Int: int -> int value
    | Bool: bool -> bool value

type _ expr =
    | Value: 'a value -> 'a expr
    | Plus: int expr * int expr -> int expr
    | Eq: int expr * int expr -> bool expr
    | If: bool expr * 'a expr * 'a expr -> 'a expr

let rec eval:  type a. a expr -> a value = function
| Value v -> v
| Plus (n, m) -> let Int n, Int m = eval n, eval m in Int (n+m)
| Eq (n, m) -> let Int n, Int m = eval n, eval m in Bool (n=m)
| If (b, x, y) -> let Bool v = eval b in if v then eval x else eval y
