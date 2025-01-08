(** Copyright 2024-2025, Kotelnikova Ksenia <xeniia.ka@gmail.com> *)

(** SPDX-License-Identifier: BSD 3-clause license *)

type atn_type =
  | Lexer
  | Parser

type atn_state =
  | InvalidState
  | RuleStartState of int
  | RuleStopState of int
  | BlockStartState of int
  | BlockEndState of int
  | LoopEndState of int
  | DecisionState of int
  | BasicState

type atn =
  { grammar_type : atn_type
  ; max_token_type : int
  ; states : atn_state list
  ; rule_to_start_state : (int * int) list
  ; rule_to_stop_state : (int * int) list
  ; mode_to_start_state : int list
  ; decision_to_state : atn_state list
  }

val get_decision_state : atn -> int -> atn_state option
val get_number_of_decisions : atn -> int
val deserialize_atn : int array -> atn
val string_of_atn_type : atn_type -> string
val string_of_atn_state : atn_state -> string
val print_atn : atn -> unit
