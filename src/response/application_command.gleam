pub type Command {
  MessageWithSource(String)
  DeferredMessageWithSource(String)
  Modal
}

pub type Autocomplete {
  StringAutocomplete(List(#(String, String)))
  IntegerAutocomplete(List(#(String, Int)))
  NumberAutocomplete(List(#(String, Float)))
}
