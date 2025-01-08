(** Copyright 2024-2025, Kotelnikova Ksenia <xeniia.ka@gmail.com> *)

(** SPDX-License-Identifier: BSD 3-clause license *)

val token_eof : int

type token =
  { token_type : int
  ; text : string
  ; start : int
  ; stop : int
  }
