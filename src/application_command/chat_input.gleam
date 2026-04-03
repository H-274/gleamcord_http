//// Based on:
//// - https://discord.com/developers/docs/interactions/application-commands#application-command-object

import application_command/interaction.{type Interaction}
import application_command/option_definition.{
  IntegerAutocompleteDefinition, NumberAutocompleteDefinition,
  StringAutocompleteDefinition,
} as co
import application_command/option_value.{IntegerValue, NumberValue, StringValue}
import application_command/response.{type Response}
import application_command/signature.{type Signature}
import gleam/dict.{type Dict}
import gleam/list

pub opaque type ChatInput(state) {
  ChatInput(
    signature: Signature,
    options: Dict(String, co.Definition(state)),
    handler: Handler(state),
  )
}

pub fn new(
  signature signature: Signature,
  opts options: List(co.Definition(state)),
  handler handler: Handler(state),
) {
  let options = list.map(options, fn(o) { #(o.name, o) }) |> dict.from_list

  ChatInput(signature:, options:, handler:)
}

pub fn get_option(chat_input: ChatInput(_), name: String) {
  dict.get(chat_input.options, name)
}

pub fn get_name(chat_input: ChatInput(_)) -> String {
  chat_input.signature.name
}

pub fn run(
  chat_input: ChatInput(state),
  i: interaction.Interaction,
  state: state,
  options: option_value.Values,
) -> Result(Response(state), Nil) {
  chat_input.handler(i, state, options) |> Ok
}

pub fn run_autocomplete(
  chat_input: ChatInput(state),
  i: interaction.Interaction,
  state: state,
  values: option_value.Values,
) -> Result(response.AutocompleteResponse, Nil) {
  let assert Ok(option) = dict.values(values) |> list.find(fn(o) { o.focused })
    as "there should always be a focused option when autocomplete is called"

  case dict.get(chat_input.options, option.name), option {
    Ok(StringAutocompleteDefinition(autocomplete: autocomplete, ..)),
      StringValue(value: partial, ..)
    ->
      autocomplete(i, state, partial, values)
      |> response.StringAutocomplete
      |> Ok
    Ok(IntegerAutocompleteDefinition(autocomplete:, ..)),
      IntegerValue(value: partial, ..)
    ->
      autocomplete(i, state, partial, values)
      |> response.IntegerAutocomplete
      |> Ok
    Ok(NumberAutocompleteDefinition(autocomplete:, ..)),
      NumberValue(value: partial, ..)
    ->
      autocomplete(i, state, partial, values)
      |> response.NumberAutocomplete
      |> Ok
    _, _ -> Error(Nil)
  }
}

pub type Handler(state) =
  fn(Interaction, state, option_value.Values) -> Response(state)
