import gleam/dict.{type Dict}

pub type AutocompleteHandler(interaction, param, bot, success, failure) =
  fn(interaction, Dict(String, param), bot) -> Result(success, failure)
