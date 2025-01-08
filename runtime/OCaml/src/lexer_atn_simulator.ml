(** Copyright 2024-2025, Kotelnikova Ksenia <xeniia.ka@gmail.com> *)

(** SPDX-License-Identifier: BSD 3-clause license *)

open Input_stream
open Atn_deserialize
open Token

module LexerATNSimulator = struct
  type token

  type t =
    { atn : atn
    ; mutable input : CharStream.t
    ; mutable current_mode : int
    }

  let create atn = { atn; input = CharStream.create ""; current_mode = 0 }

  let rec simulate_atn simulator state_index =
    let state = List.nth simulator.atn.states state_index in
    (function
      | RuleStopState _ -> 1
      | DecisionState _ ->
        let rec try_transitions = function
          | [] -> 0
          | (symbol, target_state) :: rest ->
            let next_symbol = CharStream.la simulator.input 1 in
            if symbol = next_symbol
            then (
              CharStream.consume simulator.input;
              if simulate_atn simulator target_state = 1
              then 1
              else (
                CharStream.seek simulator.input (CharStream.index simulator.input - 1);
                try_transitions rest))
            else try_transitions rest
        in
        try_transitions (get_transitions simulator state_index)
      | _ -> 0)
      state

  and get_transitions simulator state_index =
    match List.nth simulator.atn.states state_index with
    | DecisionState decision_index ->
      let state = List.nth simulator.atn.decision_to_state decision_index in
      extract_transitions state
    | _ -> []

  and extract_transitions = function
    | DecisionState decision -> [ decision, decision + 1 ]
    | _ -> []
  ;;

  let next_token simulator =
    let start_index = CharStream.index simulator.input in
    let rec match_loop state_index =
      if simulate_atn simulator state_index = 1
      then (
        let text =
          CharStream.get_text
            simulator.input
            (start_index, CharStream.index simulator.input - 1)
        in
        Some
          { token_type = state_index
          ; text
          ; start = start_index
          ; stop = CharStream.index simulator.input - 1
          })
      else if CharStream.la simulator.input 1 = IntStream.eof
      then None
      else (
        CharStream.consume simulator.input;
        match_loop state_index)
    in
    match List.nth_opt simulator.atn.mode_to_start_state simulator.current_mode with
    | Some start_state_index -> match_loop start_state_index
    | None -> None
  ;;
end
