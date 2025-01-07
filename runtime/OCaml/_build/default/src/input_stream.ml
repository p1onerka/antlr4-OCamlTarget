module IntStream = struct
  type t =
    { mutable index : int
    ; input : int array
    ; size : int
    }

  let eof = -1
  let unknown_source_name = "<unknown>"
  let create input = { index = 0; input; size = Array.length input }

  let consume stream =
    if stream.index >= stream.size
    then failwith "Attempt to consume EOF"
    else stream.index <- stream.index + 1
  ;;

  let la stream i =
    let pos = stream.index + i - 1 in
    if pos < 0 || pos >= stream.size then eof else stream.input.(pos)
  ;;

  let mark stream = stream.index
  let release _marker = ()

  let seek stream i =
    if i < 0 then invalid_arg "Negative index" else stream.index <- min i stream.size
  ;;

  let size stream = stream.size
  let index stream = stream.index
  let get_source_name _ = unknown_source_name
end

module CharStream = struct
  type t =
    { base : IntStream.t
    ; text : string
    }

  let create text =
    let char_codes = Array.init (String.length text) (fun i -> Char.code text.[i]) in
    { base = IntStream.create char_codes; text }
  ;;

  let from_string s = create s

  let get_text stream (start, stop) =
    if start < 0 || stop >= stream.base.size || start > stop
    then invalid_arg "Invalid interval"
    else String.sub stream.text start (stop - start + 1)
  ;;

  let consume stream = IntStream.consume stream.base
  let la stream i = IntStream.la stream.base i
  let mark stream = IntStream.mark stream.base

  (*let release stream marker = IntStream.release marker*)
  let seek stream index = IntStream.seek stream.base index
  let size stream = IntStream.size stream.base
  let index stream = IntStream.index stream.base
  let get_source_name stream = IntStream.get_source_name stream.base
end
