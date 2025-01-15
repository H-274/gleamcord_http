import gleam/dynamic
import gleam/list
import gleam/string

pub fn decode_errors(errors: List(dynamic.DecodeError)) {
  "List(DecodeError):\n" <> string.join(list.map(errors, decode_error), ",\n")
}

pub fn decode_error(error: dynamic.DecodeError) {
  string.join(
    [
      "{",
      "    Expected: " <> error.expected,
      "    Found: " <> error.found,
      "    At path: " <> string.join(error.path, "/"),
      "}",
    ],
    "\n",
  )
}
