(** Copyright 2024-2025, Kotelnikova Ksenia <xeniia.ka@gmail.com> *)

(** SPDX-License-Identifier: BSD 3-clause license *)

module IntStream : sig
  type t

  val eof : int
  val unknown_source_name : string
  val create : int array -> t
  val consume : t -> unit
  val la : t -> int -> int
  val mark : t -> int
  val release : int -> unit
  val seek : t -> int -> unit
  val size : t -> int
  val index : t -> int
  val get_source_name : t -> string
end

module CharStream : sig
  type t

  val create : string -> t
  val from_string : string -> t
  val get_text : t -> int * int -> string
  val consume : t -> unit
  val la : t -> int -> int
  val mark : t -> int
  val seek : t -> int -> unit
  val size : t -> int
  val index : t -> int
  val get_source_name : t -> string
end
