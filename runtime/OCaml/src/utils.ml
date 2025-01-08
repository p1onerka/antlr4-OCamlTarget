(** Copyright 2024-2025, Kotelnikova Ksenia <xeniia.ka@gmail.com> *)

(** SPDX-License-Identifier: BSD 3-clause license *)

let str_list (val_list : 'a list) : string =
  let buf = Buffer.create 16 in
  Buffer.add_char buf '[';
  let rec aux first = function
    | [] -> ()
    | x :: xs ->
      if not first then Buffer.add_string buf ", ";
      Buffer.add_string buf (string_of_int x);
      (* maybe change to another func later? *)
      aux false xs
  in
  aux true val_list;
  Buffer.add_char buf ']';
  Buffer.contents buf
;;

let escape_whitespace (s : string) (escape_spaces : bool) : string =
  let buf = Buffer.create (String.length s) in
  String.iter
    (fun c ->
      match c with
      | ' ' when escape_spaces -> Buffer.add_string buf " "
      | '\t' -> Buffer.add_string buf "\\t"
      | '\n' -> Buffer.add_string buf "\\n"
      | '\r' -> Buffer.add_string buf "\\r"
      | _ -> Buffer.add_char buf c)
    s;
  Buffer.contents buf
;;
