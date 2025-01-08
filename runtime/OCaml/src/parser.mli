(** Copyright 2024-2025, Kotelnikova Ksenia <xeniia.ka@gmail.com> *)

(** SPDX-License-Identifier: BSD 3-clause license *)

exception ParseError of string

val num : Token.token -> unit
