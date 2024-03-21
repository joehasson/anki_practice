(* utilities *)
let charlist_to_string chars =
    chars |> List.to_seq |> String.of_seq

module Input = struct
    type position = {line: int; column: int}
    let init_pos = {line=0; column=0}

    let incr_col pos = {pos with column=pos.column+1}
    let incr_line pos = {line=pos.line+1; column=0}

    type t = {lines: string array; position: position}

    let current_line input_state =
        let line = input_state.position.line in
        if line < Array.length input_state.lines
        then input_state.lines.(line)
        else "EOF"

    let of_string s = 
        let chars = String.to_seq s in
        let rec split_lines acc chars = let open Seq in match chars() with
        | Nil -> acc
        | Cons ('\r', chars) -> (
            match chars() with
            | Nil -> []::acc
            | Cons ('\n', chars') -> split_lines ([]::acc) chars'
            | Cons _ -> split_lines ([]::acc) chars
        )
        | Cons ('\n', chars) -> 
                split_lines ([]::acc) chars
        | Cons (ch, chars) -> 
            let acc' = (match acc with
                | [] -> [[ch]]
                | []::lines -> [ch]::lines
                | line::lines -> (ch::line)::lines
            ) in split_lines acc' chars
        in 
        let lines_as_charlists = List.rev (List.map List.rev (split_lines [] chars))
        in let lines = List.map charlist_to_string lines_as_charlists
        in {lines=Array.of_list lines; position={line=0; column=0}}

    let next_char input_state : t * char option =
        let {line; column} = input_state.position in
        let linecount = Array.length input_state.lines in
        if line >= linecount then 
            input_state, None
        else
            let cur_line = input_state.lines.(line) in
            if column < String.length cur_line then 
                let ch = String.get cur_line column in
                let new_pos = incr_col input_state.position in
                let new_state = {input_state with position=new_pos} in
                new_state, Some ch
            else
                let ch = '\n' in
                let new_pos = incr_line input_state.position in
                let new_state = {input_state with position=new_pos} in
                new_state, Some ch
end

(* Parser definition and utilities *)

(** Stores information about parser_position for error messaging *)
type parser_position = {
    current_line: string;
    line: int;
    column: int
}

type err = {
    position: parser_position;
    label: string;
    msg: string;
}

type 'a parse_result = ('a, err) result

type 'a parser = Parser of {
    parse_fn: Input.t -> ('a * Input.t) parse_result;
    label: string
}

let run_on_input parser input =
    let Parser {parse_fn; _} = parser in
    parse_fn input

let run parser string =
    let input = Input.of_string string in
    run_on_input parser input

(* Parser error messaging *)

let parser_position_of_input input = {
    current_line = Input.current_line input;
    line = input.position.line;
    column = input.position.column
}

let print_result = function
| Ok _ -> print_string "ok"
| Error {position; label; msg} ->
        let failure_caret = Printf.sprintf "%*s^%s" position.column "" msg in
        Printf.printf
            "line: %d col: %d Error parsing %s\n%s\n%s\n"
                position.line position.column
                label
                position.current_line
                failure_caret

(* label utils *)
let get_label (Parser inner) =
    inner.label

let set_label parser newlabel = 
    let new_parsefn input = match run_on_input parser input with
    | Ok k -> Ok k
    | Error e -> Error {e with label=newlabel}
    in Parser {parse_fn=new_parsefn; label=newlabel}

let ( <?> ) = set_label

(** Parse a token if the predicate is satisfied *)
let satisfy predicate label =
    let parse_fn input =
        let remaining_input, char_opt = Input.next_char input in
        match char_opt with
        | None -> Error {
            position=parser_position_of_input remaining_input;
            label=label;
            msg="no more input"
            }
        | Some ch ->
                if predicate ch
                then Ok (ch, remaining_input)
                else Error {
                    position=parser_position_of_input remaining_input;
                    label=label;
                    msg= Printf.sprintf "Unexpected character: %c" ch
                }
    in Parser {parse_fn; label}


let bindP f p =
    let label = "unknown" in 
    let parse_fn input = match run_on_input p input with
    | Ok (a, rest) -> let pb = f a in run_on_input pb rest
    | Error msg -> Error msg
    in Parser {parse_fn; label}

let ( >>= ) p f = bindP f p

let returnP x =
    let label = "unknown" in
    let parse_fn input = Ok (x, input) in 
    Parser {parse_fn; label}

let ( >> ) f g x = g (f x)
let mapP f p =
    p >>= (f >> returnP)

let ( |>> ) p f = mapP f p

let applyP fP xP =
    fP >>= (fun f ->
    xP >>= (fun x ->
        returnP (f x)))

let ( <*> ) = applyP

(* (a -> b -> c) -> a parser -> b parser -> c parser *)
let lift2 f xP yP =
    returnP f <*> xP <*> yP

let and_then aP bP =
    let label = Printf.sprintf "%s and then %s" (get_label aP) (get_label bP) in
    aP >>= (fun a ->
    bP >>= (fun b ->
        returnP (a, b)))
    <?> label

let ( >>> ) = and_then

let or_else aP bP =
    let label = Printf.sprintf "%s or else %s" (get_label aP) (get_label bP) in
    let parse_fn input = match run_on_input aP input with
    | Ok ok -> Ok ok
    | Error _ -> run_on_input bP input
    in Parser {parse_fn; label}

let ( <|> ) = or_else

let sequence parsers =
    let cons aP aPs = 
        aP >>= (fun x ->
        aPs >>= (fun xs ->
            returnP (x :: xs)))
    in 
    List.fold_right cons parsers (returnP [])

