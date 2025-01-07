open Token

exception ParseError of string

let num token =
  match token with
  | { token_type = 1; text; start; stop } ->
    Printf.printf "Parsed INT: %s, Start: %d, Stop: %d\n" text start stop
  | _ -> raise (ParseError "Expected an INT token")
;;
