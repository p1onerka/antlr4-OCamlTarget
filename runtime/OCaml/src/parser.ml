(** Copyright 2024-2025, Kotelnikova Ksenia <xeniia.ka@gmail.com> *)

(** SPDX-License-Identifier: BSD 3-clause license *)

open Token

exception ParseError of string

let num = function
  | { token_type = 1; text; start; stop } ->
    Printf.printf "Parsed INT: %s, Start: %d, Stop: %d\n" text start stop
  | _ -> raise (ParseError "Expected an INT token")
;;

let%expect_test "num_valid_token" =
  let token = { token_type = 1; text = "123"; start = 0; stop = 3 } in
  num token;
  [%expect {|
    Parsed INT: 123, Start: 0, Stop: 3
  |}]
;;

let%expect_test "num_invalid_token" =
  let token = { token_type = 2; text = "abc"; start = 0; stop = 3 } in
  try num token with
  | ParseError msg ->
    Printf.printf "Error: %s\n" msg;
    [%expect {|
    Error: Expected an INT token
  |}]
;;

let%expect_test "num_empty_token" =
  let token = { token_type = 1; text = ""; start = 0; stop = 0 } in
  num token;
  [%expect {|
    Parsed INT: , Start: 0, Stop: 0
  |}]
;;
