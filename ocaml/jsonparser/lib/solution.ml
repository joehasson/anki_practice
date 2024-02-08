(* Utilities *)
let charlist_to_string chars = chars |> List.to_seq |> String.of_seq
let string_to_charlist s = s |> String.to_seq |> List.of_seq

let ( >> ) f g x = g (f x)

(* Managing Input state *)
module Input = struct
    type position = {
        line: int;
        column: int
    }
    let initial_pos = {line=0; column=0}

    let incr_col position = {
        line = position.line;
        column = position.column+1
    }

    let incr_line position = {
        line = position.line + 1;
        column = 0;
    }

    type t = {
        lines: string array;
        position: position
    }

    (** Get the current line *)
    let current_line input =
        let line = input.position.line in
        if line < Array.length input.lines
        then input.lines.(input.position.line)
        else "end of file"

    (** Current implementation of this is dumb af! *)
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

    let next_char input =
        (* Three cases *)
        (* (Case 1) line >= maxline *)
        if input.position.line >= Array.length input.lines
        then None, input
        else 
        let line = input.lines.(input.position.line) in
        (* (Case 2) line < maxline and col = line length *)
        if input.position.column = String.length line
        then
            let new_position = {line=input.position.line+1; column=0} in
            Some '\n', {input with position=new_position}
        (* (Case 3) line < maxline and col < line length *)
        else
            let ch = String.get line input.position.column in
            let new_position = {line=input.position.line; column=input.position.column+1} in
            Some ch, {input with position=new_position}
end

(* Basic parser types and operations *)
type parser_position = {current_line: string; line: int; column: int}

let parser_position_from_input_state (input: Input.t) = {
    current_line = input.lines.(input.position.line);
    line = input.position.line;
    column = input.position.column;
}
     
type error = {label: string; err: string; position: parser_position}
type 'a parse_result = ('a, error) result

let print_parse_result = function
| Ok _ -> print_endline "ok"
| Error {label; err; position={current_line; line; column}} ->
        let failure_caret = Printf.sprintf "%*s^%s" column "" err in
        Printf.printf 
            "Line: %d Col: %d Error parsing %s\n%s\n%s\n"
            line column label
            current_line failure_caret

type 'a parser = Parser of {
    parseFn: Input.t -> 'a parse_result * Input.t;
    label: string;
}

(* Parser utilities *)
let run parser input = let Parser {parseFn; _} = parser in parseFn input
let label parser = let Parser {label; _} = parser in label
let runs parser s =
    let input = Input.of_string s in run parser input

(* Displaying error results *)

(* Parser combinator library *)

let bindP f parser =
    let parseFn input = match run parser input with
    | (Ok x, input) -> run (f x) input
    | (Error _, _) as e -> e
    in Parser {parseFn; label=label parser}

let ( >>= ) parser f = bindP f parser

let returnP a =
    let parseFn input = (Ok a, input) in
    Parser {parseFn; label="unknown"}

let mapP f parser =
    parser >>= (f >> returnP)

let ( |>> ) parser f = mapP f parser

let applyP fP xP =
    fP >>= (fun f -> xP |>> f)

let ( <*> ) = applyP

let relabel parser newlabel =
    let Parser data = parser in
    Parser {data with label=newlabel}

let ( <?> ) parser newlabel = relabel parser newlabel

let lift2 f xP yP =
    returnP f <*> xP <*> yP

let sequence parsers =
    let cons hd tl = hd :: tl in
    let consP = lift2 cons in
    List.fold_right consP parsers (returnP []) 

let andthen xP yP =
    let label = Printf.sprintf "%s and %s" (label xP) (label yP) in
    xP >>= (fun res1 ->
    yP >>= (fun res2 ->
        returnP (res1, res2) <?> label))

let ( >>> ) = andthen

let orelse xP yP =
    let parseFn input = match run xP input with
    | Error _, _ -> run yP input
    | ok -> ok
    in Parser {parseFn; label="or"}

let ( <|> ) = orelse

let takeleft xP yP =
    xP >>> yP |>> fst

let ( ->> ) = takeleft

let takeright xP yP =
    xP >>> yP |>> snd

let ( >>- ) = takeright

let between xP yP zP = xP >>- yP ->> zP

let choice parsers = match parsers with
| [] -> failwith "figure out a better way to handle this"
| x :: xs -> List.fold_right orelse xs x

(** Parse zero or more input with parser *)
let many parser =
    let rec parse_zero_or_more parser input = match run parser input with
    | Error _, input -> ([], input)
    | Ok x, rest ->
            let xs, remaining = parse_zero_or_more parser rest in
            (x::xs, remaining)
    in
    let parseFn input = 
        let result, rest = parse_zero_or_more parser input in
        Ok result, rest
    in Parser {parseFn; label="many " ^ label parser}

(** Parse one or more input with parser *)
let many1 parser = 
    parser >>> many parser |>> (fun (a,b) -> List.cons a b)

let many_chars chp =
    many chp |>> charlist_to_string

let many_chars1 chp =
    many1 chp |>> charlist_to_string

let sep_by valP sepP =
    let sep_by_1 =
        let sep_then_p = sepP >>- valP in
        valP >>> many sep_then_p
        |>> (fun (x, xs) -> x::xs)
    in
    sep_by_1 <|> returnP []

(* Json definition *)
module StringMap = Map.Make(struct
    type t = string
    let compare = String.compare
end)

type json =
    | JsonNull
    | JsonBool of bool
    | JsonString of string
    | JsonNumber of float
    | JsonArray of json list
    (* Ideally you would represent this as a JsonString stringmap? food for thought *)
    | JsonObject of json StringMap.t

(* The parser *)
let satisfy predicate label =
    let parseFn input = match Input.next_char input with
    | Some nch, rest -> 
        if predicate nch 
        then Ok nch, rest
        else 
            let err = Printf.sprintf "Unexpected %s" (Char.escaped nch) in
            let position = parser_position_from_input_state input in
            Error {err; label; position}, input
    | None, _ ->
        let err = "no more input" in
        let position = parser_position_from_input_state input in
        Error {err; label; position}, input
    in Parser {parseFn; label}

(** [pchar ch] is a parser which parses only the character [ch] *)
let pchar ch = satisfy (fun nch -> nch = ch) (String.make 1 ch)

let pstring s =
    s |> string_to_charlist
      |> List.map pchar
      |> sequence
      |>> charlist_to_string
      <?> s

let pjnull = pstring "null" >>= (fun s -> returnP (JsonString s)) <?> "null"
let pjtrue = pstring "true" >>= (fun _ -> returnP (JsonBool true)) <?> "true"
let pjfalse = pstring "false" >>= (fun _ -> returnP (JsonBool false)) <?> "false"

let pjbool = pjtrue <|> pjfalse <?> "bool"

let pwhitespace =
    let p1whitespace = satisfy (fun ch -> 
        ch = '\n' || ch = '\r' || ch = '\t' || ch = ' '
    ) "whitespace" in many p1whitespace |>> (fun _ -> [])

let pjchar =
    let punescapedchar =
        satisfy (fun ch -> ch <> '\\' && ch <> '\"' && ch <> '"') "unescaped char"
    in
    let pescapedchar = 
        pchar '\\' >>- choice [
            pchar '"' >>- returnP '"';
            pchar '\\' >>- returnP '\\';
            pchar 'b' >>- returnP '\b';
            pchar 'f' >>- returnP '\x0C';
            pchar 'n' >>- returnP '\n';
            pchar 'r' >>- returnP '\r';
            pchar 't' >>- returnP '\t';
        ]
    in punescapedchar <|> pescapedchar <?> "char"


let pjstring = 
    let pquote = pchar '\"' <?> "quote" in
    between pquote (many pjchar) pquote
    |>> (fun chars -> JsonString (charlist_to_string chars))
    <?> "string"

let opt parser =
    let parseFn input = match run parser input with
    | Error _, _ -> Ok None, input
    | Ok x, rest -> Ok (Some x), rest
    in Parser {parseFn; label="optional " ^ label parser}

let pjnumber =
    let optSign = opt (pchar '-') in
    let zero = pstring "0" in
    let char_is_digit ch =
        ch = '0' || ch = '1'|| ch = '2'|| ch = '3'|| ch = '4'
        || ch = '5'|| ch = '6'|| ch = '7' || ch = '8' || ch = '9'
    in
    let digitOneNine =
        satisfy (fun ch -> char_is_digit ch && ch <> '0') "1-9"
    in 
    let digit = satisfy char_is_digit "digit" in
    let point = pchar '.' in
    let e = pchar 'e' <|> pchar 'E' in
    let optPlusMinus = opt (pchar '-' <|> pchar '+') in
    let nonZeroInt =
        digitOneNine >>> many_chars digit
        |>> fun (first,rest) -> String.make 1 first ^ rest
    in
    let intPart = zero <|> nonZeroInt in
    let fractionPart = point >>- many_chars1 digit in
    let exponentPart = e >>- optPlusMinus >>> many_chars1 digit in
    let numberparser = optSign >>> intPart >>> opt fractionPart >>> opt exponentPart in
    let convert_to_jnumber (((sign_opt, intpart), fracpart_opt), expopt) =
        let intpartnum = match sign_opt with
        | None -> float_of_string intpart 
        | Some _neg -> -1.0 *. float_of_string intpart
        in
        let fracpartnum = match fracpart_opt with
        | None -> 0.0
        | Some s -> float_of_string (Printf.sprintf "0.%s" s)
        in 
        let exppartnum = match expopt with
        | None -> 1.0
        | Some (sign, s) -> 
                match sign with
                | Some '-' -> -1.0 *. float_of_string s
                | None | Some _ -> float_of_string s
        in JsonNumber ((intpartnum +. fracpartnum) ** exppartnum)
    in
    numberparser |>> convert_to_jnumber 
    <?> "number"

let create_parser_forwarded_to_ref () =
  let dummyParser =
    let innerFn _ = failwith "unfixed forwarded parser" in
    Parser {parseFn=innerFn; label="unknown"}
  in
  let parserRef = ref dummyParser in
  let innerFn input = run !parserRef input in
  let wrapperParser = Parser {parseFn=innerFn; label="unknown"} in
  wrapperParser, parserRef

let json_parser, json_parser_ref = create_parser_forwarded_to_ref ()

let pjarray =
    let left = pchar '[' in
    let right = pchar ']' in
    let comma = pchar ',' in
    let parse_elements = sep_by json_parser comma in
    between left (parse_elements <|> pwhitespace) right
    |>> (fun list -> JsonArray list)
    <?> "array"

let pjobject =
    let left = pchar '{' in
    let right = pchar '}' in
    let comma = pchar ',' in
    let colon = pchar ':' in
    let binding_parser = 
        let pkey = between pwhitespace pjstring colon in
        let pvalue = pwhitespace >>- json_parser in
        pkey >>> pvalue
        |>> (function
            | (JsonString s, e) -> s, e
            | _ -> failwith "impossible")
    in
    let bindings_parser = sep_by binding_parser comma in
    between left (bindings_parser <|> pwhitespace) right
    |>> StringMap.of_list
    |>> (fun map -> JsonObject map)
    <?> "object"

(* Fix the forward reference to json_parser *)
let () =
    let val_opts = choice [
        pjnull;
        pjbool;
        pjnumber;
        pjstring;
        pjarray;
        pjobject
    ] in
    let json_parser = between pwhitespace val_opts pwhitespace <?> "json value"
    in json_parser_ref := json_parser

