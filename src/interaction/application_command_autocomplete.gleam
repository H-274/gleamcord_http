import gleam/dict.{type Dict}
import interaction.{type AutocompleteInteraction}
import interaction/response

pub type AutocompleteHandler(param, bot) =
  fn(AutocompleteInteraction, Dict(String, param), bot) ->
    Result(response.Success, response.Failure)
