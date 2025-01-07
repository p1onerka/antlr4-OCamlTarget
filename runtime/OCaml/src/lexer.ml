open Atn_deserialize
open Lexer_atn_simulator

let tokenize serializedATN =
  let atn = deserialize_atn serializedATN in
  let lexer_simulator = LexerATNSimulator.create atn in
  let rec aux acc =
    match LexerATNSimulator.next_token lexer_simulator with
    | None -> List.rev acc
    | Some token -> aux (token :: acc)
  in
  aux []
;;
