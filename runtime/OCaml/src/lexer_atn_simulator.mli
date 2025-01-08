(** Copyright 2024-2025, Kotelnikova Ksenia <xeniia.ka@gmail.com> *)

(** SPDX-License-Identifier: BSD 3-clause license *)

open Input_stream
open Atn_deserialize

module LexerATNSimulator : sig
  type token

  type t =
    { atn : atn
    ; mutable input : CharStream.t
    ; mutable current_mode : int
    }

  val create : atn -> t
  val simulate_atn : t -> int -> int
  val next_token : t -> Token.token option
end
