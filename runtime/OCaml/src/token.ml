let token_eof = -1

type token =
  { token_type : int
  ; text : string
  ; start : int
  ; stop : int
  }
