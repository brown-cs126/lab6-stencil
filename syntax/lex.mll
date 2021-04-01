{
  open Parse

  exception Error of string
}


rule token = parse
| [' ' '\t'] (* also ignore newlines, not only whitespace and tabs *)
    { token lexbuf }
| '\n' { NEWLINE }
| '+'
    { PLUS }
| "print"
    { PRINT }
| ['0'-'9']+ as i
    { NUMBER (float_of_string i) }
| eof
    { EOF }
| _
    { raise (Error (Printf.sprintf "At offset %d: unexpected character.\n" (Lexing.lexeme_start lexbuf))) }
