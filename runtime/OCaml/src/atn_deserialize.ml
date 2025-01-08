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

exception ATNError of string

let get_decision_state atn decision =
  if decision < 0 || decision >= List.length atn.decision_to_state
  then None
  else Some (List.nth atn.decision_to_state decision)
;;

let get_number_of_decisions atn = List.length atn.decision_to_state

let deserialize_atn data =
  let p = ref 0 in
  let read () =
    let value = Array.get data !p in
    incr p;
    value
  in
  let version = read () in
  if version <> 4 then raise (ATNError "Incorrect ATN version");
  let grammar_type =
    match read () with
    | 0 -> Lexer
    | 1 -> Parser
    | _ -> raise (ATNError "Invalid grammar type")
  in
  let max_token_type = read () in
  let atn =
    { grammar_type
    ; max_token_type
    ; states = []
    ; rule_to_start_state = []
    ; rule_to_stop_state = []
    ; mode_to_start_state = []
    ; decision_to_state = []
    }
  in
  (* States *)
  let nstates = read () in
  let states = ref [] in
  let decision_to_state = ref [] in
  for _ = 1 to nstates do
    let stype = read () in
    let state =
      match stype with
      | 0 -> InvalidState
      | 1 -> RuleStartState (read ())
      | 2 -> RuleStopState (read ())
      | 3 -> BlockStartState (read ())
      | 4 -> BlockEndState (read ())
      | 5 -> LoopEndState (read ())
      | 6 -> DecisionState (read ())
      | _ -> BasicState
    in
    states := state :: !states;
    if match state with
       | DecisionState _ -> true
       | _ -> false
    then decision_to_state := state :: !decision_to_state
  done;
  (* Rules *)
  let nrules = read () in
  let rule_to_start_state = ref [] in
  for i = 1 to nrules do
    let start_state = read () in
    rule_to_start_state := (i, start_state) :: !rule_to_start_state
  done;
  (* Modes *)
  let nmodes = read () in
  let mode_to_start_state = ref [] in
  for _ = 1 to nmodes do
    mode_to_start_state := read () :: !mode_to_start_state
  done;
  { atn with
    states = List.rev !states
  ; rule_to_start_state = List.rev !rule_to_start_state
  ; mode_to_start_state = List.rev !mode_to_start_state
  ; decision_to_state = List.rev !decision_to_state
  }
;;

let string_of_atn_type = function
  | Lexer -> "Lexer"
  | Parser -> "Parser"
;;

let string_of_atn_state = function
  | InvalidState -> "InvalidState"
  | RuleStartState rule -> Printf.sprintf "RuleStartState(rule=%d)" rule
  | RuleStopState rule -> Printf.sprintf "RuleStopState(rule=%d)" rule
  | BlockStartState block -> Printf.sprintf "BlockStartState(block=%d)" block
  | BlockEndState block -> Printf.sprintf "BlockEndState(block=%d)" block
  | LoopEndState loop -> Printf.sprintf "LoopEndState(loop=%d)" loop
  | DecisionState decision -> Printf.sprintf "DecisionState(decision=%d)" decision
  | BasicState -> "BasicState"
;;

let print_atn atn =
  Printf.printf "ATN:\n";
  Printf.printf "  Grammar type: %s\n" (string_of_atn_type atn.grammar_type);
  Printf.printf "  Max token type: %d\n" atn.max_token_type;
  Printf.printf "\nStates (%d):\n" (List.length atn.states);
  List.iteri
    (fun idx state -> Printf.printf "  [%d] %s\n" idx (string_of_atn_state state))
    atn.states;
  Printf.printf "\nRules (%d):\n" (List.length atn.rule_to_start_state);
  List.iter
    (fun (rule_index, start_state) ->
      Printf.printf "  Rule %d -> StartState %d\n" rule_index start_state)
    atn.rule_to_start_state;
  Printf.printf "\nStop States (%d):\n" (List.length atn.rule_to_stop_state);
  List.iter
    (fun (rule_index, stop_state) ->
      Printf.printf "  Rule %d -> StopState %d\n" rule_index stop_state)
    atn.rule_to_stop_state;
  Printf.printf "\nModes (%d):\n" (List.length atn.mode_to_start_state);
  List.iteri
    (fun idx mode_start -> Printf.printf "  Mode %d -> StartState %d\n" idx mode_start)
    atn.mode_to_start_state;
  Printf.printf "\nDecisions (%d):\n" (get_number_of_decisions atn);
  List.iteri
    (fun idx state ->
      Printf.printf "  Decision %d -> %s\n" idx (string_of_atn_state state))
    atn.decision_to_state
;;

let%expect_test "deserialize_atn_test" =
  let data = [| 4; 1; 10; 3; 1; 1; 2; 2; 6; 0; 2; 10; 20; 1; 30 |] in
  let deserialized_atn = deserialize_atn data in
  print_atn deserialized_atn;
  [%expect
    {|
    ATN:
      Grammar type: Parser
      Max token type: 10

    States (3):
      [0] RuleStartState(rule=1)
      [1] RuleStopState(rule=2)
      [2] DecisionState(decision=0)

    Rules (2):
      Rule 1 -> StartState 10
      Rule 2 -> StartState 20

    Stop States (0):

    Modes (1):
      Mode 0 -> StartState 30

    Decisions (1):
      Decision 0 -> DecisionState(decision=0)
  |}]
;;
