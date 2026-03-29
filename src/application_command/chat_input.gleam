import application_command/interaction.{type Interaction}
import application_command/option_value.{IntegerValue, NumberValue, StringValue}
import application_command/response.{type Response}
import application_command/signature.{
  type Signature, AutocompleteIntegerOption, AutocompleteNumberOption,
  AutocompleteStringOption, IntegerOption, NumberOption, StringOption,
}
import gleam/dict.{type Dict}
import gleam/list

pub opaque type ChatInput(state) {
  ChatInput(
    signature: Signature,
    options: Dict(String, signature.CommandOption(state)),
    handler: Handler(state),
  )
}

pub fn new(
  signature signature: Signature,
  opts options: List(signature.CommandOption(state)),
  handler handler: Handler(state),
) {
  let options = list.map(options, fn(o) { #(o.name, o) }) |> dict.from_list

  ChatInput(signature:, options:, handler:)
}

pub fn get_option(chat_input: ChatInput(_), name: String) {
  dict.get(chat_input.options, name)
}

pub fn get_signature(chat_input: ChatInput(_)) {
  chat_input.signature
}

pub fn run(
  chat_input: ChatInput(state),
  i: interaction.Interaction,
  state: state,
  options: option_value.Values,
) -> Result(Response, Nil) {
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
    Ok(StringOption(details: AutocompleteStringOption(autocomplete:, ..), ..)),
      StringValue(value: partial, ..)
    ->
      autocomplete(i, state, values, partial)
      |> response.StringAutocomplete
      |> Ok
    Ok(IntegerOption(details: AutocompleteIntegerOption(autocomplete:, ..), ..)),
      IntegerValue(value: partial, ..)
    ->
      autocomplete(i, state, values, partial)
      |> response.IntegerAutocomplete
      |> Ok
    Ok(NumberOption(details: AutocompleteNumberOption(autocomplete:, ..), ..)),
      NumberValue(value: partial, ..)
    ->
      autocomplete(i, state, values, partial)
      |> response.NumberAutocomplete
      |> Ok
    _, _ -> Error(Nil)
  }
}

pub type Handler(state) =
  fn(Interaction, state, option_value.Values) -> Response
