import command/interaction.{type Interaction}
import command/option_value
import gleam/dict.{type Dict}
import gleam/list
import message
import modal/modal
import response

pub opaque type Command(state) {
  ChatInput(
    signature: Signature,
    options: List(#(String, Option(state))),
    handler: ChatInputHandler(state),
  )
  Group(signature: Signature, elements: Dict(String, Element(state)))
  User(signature: Signature, handler: UserHandler(state))
  Message(signature: Signature, handler: MessageHandler(state))
}

pub fn chat_input(
  sig signature: Signature,
  opts options: List(Option(_)),
  handler handler: ChatInputHandler(_),
) -> Command(_) {
  let options =
    options
    |> list.map(fn(o) { #(o.name, o) })

  ChatInput(signature:, options:, handler:)
}

pub fn group(
  sig signature: Signature,
  elements elements: List(Element(_)),
) -> Command(_) {
  let elements =
    elements
    |> list.map(fn(e) {
      case e {
        GroupElement(name:, ..) -> #(name, e)
        SubcommandElement(s) -> #(s.name, e)
      }
    })
    |> dict.from_list

  Group(signature:, elements:)
}

pub fn user(
  sig signature: Signature,
  handler handler: UserHandler(_),
) -> Command(_) {
  User(signature:, handler:)
}

pub fn message(
  sig signature: Signature,
  handler handler: MessageHandler(_),
) -> Command(_) {
  Message(signature:, handler:)
}

pub fn to_tuple(command: Command(_)) -> #(String, Command(_)) {
  #(command.signature.name, command)
}

pub type Signature {
  Signature(
    name: String,
    description: String,
    default_member_permissions: String,
    integrations: List(Nil),
    contexts: List(Nil),
    nsfw: Bool,
  )
}

pub fn simple_signature(
  name name: String,
  desc description: String,
) -> Signature {
  Signature(
    name:,
    description:,
    default_member_permissions: "",
    integrations: [],
    contexts: [],
    nsfw: False,
  )
}

pub type Option(state) {
  StringOption(
    name: String,
    description: String,
    required: Bool,
    min_len: Int,
    max_len: Int,
  )
  StringChoiceOption(
    name: String,
    description: String,
    required: Bool,
    choices: List(#(String, String)),
  )
  StringAutocompleteOption(
    name: String,
    description: String,
    required: Bool,
    min_len: Int,
    max_len: Int,
    autocomplete: AutocompleteHandler(state, String),
  )
  IntegerOption(
    name: String,
    description: String,
    required: Bool,
    min_val: Int,
    max_val: Int,
  )
  IntegerChoiceOption(
    name: String,
    description: String,
    required: Bool,
    choices: List(#(String, Int)),
  )
  IntegerAutocompleteOption(
    name: String,
    description: String,
    required: Bool,
    min_val: Int,
    max_val: Int,
    autocomplete: AutocompleteHandler(state, Int),
  )
  BooleanOption(name: String, description: String, required: Bool)
  UserOption(name: String, description: String, required: Bool)
  ChannelOption(
    name: String,
    description: String,
    required: Bool,
    channel_types: List(Nil),
  )
  RoleOption(name: String, description: String, required: Bool)
  MentionableOption(name: String, description: String, required: Bool)
  NumberOption(
    name: String,
    description: String,
    required: Bool,
    min_val: Float,
    max_val: Float,
  )
  NumberChoiceOption(
    name: String,
    description: String,
    required: Bool,
    chcoices: List(#(String, Float)),
  )
  NumberAutocompleteOption(
    name: String,
    description: String,
    required: Bool,
    min_val: Float,
    max_val: Float,
    autocomplete: AutocompleteHandler(state, Float),
  )
  AttachmentOption(name: String, description: String, required: Bool)
}

pub type ChatInputHandler(state) =
  fn(Interaction, Dict(String, option_value.Value), state) -> Response(state)

pub type UserHandler(state) =
  fn(Interaction, state) -> Response(state)

pub type MessageHandler(state) =
  fn(Interaction, state) -> Response(state)

pub type Response(state) {
  MessageResponse(message.New)
  DeferredMessageResponse(fn() -> message.New)
  ModalResponse(modal.Modal(state))
}

pub fn map_response(response response: Response(_)) {
  case response {
    MessageResponse(r) -> response.MessageWithSource(r)
    DeferredMessageResponse(r) -> response.DeferredMessageWithSource(r)
    ModalResponse(r) -> response.Modal(r)
  }
}

pub type AutocompleteHandler(state, t) =
  fn(Interaction, Dict(String, option_value.Value), t, state) ->
    List(#(String, t))

pub type AutocompleteResponse {
  StringAutocompleteResponse(List(#(String, String)))
  IntegerAutocompleteResponse(List(#(String, Int)))
  NumberAutocompleteResponse(List(#(String, Float)))
}

pub opaque type Element(state) {
  GroupElement(
    name: String,
    description: String,
    subcommands: Dict(String, Subcommand(state)),
  )
  SubcommandElement(Subcommand(state))
}

pub fn group_element(
  name name: String,
  desc description: String,
  sub subcommands: List(Subcommand(_)),
) -> Element(_) {
  let subcommands =
    subcommands
    |> list.map(fn(s) { #(s.name, s) })
    |> dict.from_list

  GroupElement(name:, description:, subcommands:)
}

pub fn subcommand_element(subcommand: Subcommand(_)) -> Element(_) {
  SubcommandElement(subcommand)
}

pub opaque type Subcommand(state) {
  Subcommand(
    name: String,
    description: String,
    options: List(#(String, Option(state))),
    handler: ChatInputHandler(state),
  )
}

pub fn subcommand(
  name name: String,
  desc description: String,
  opts options: List(Option(_)),
  handler handler: ChatInputHandler(_),
) -> Subcommand(_) {
  let options =
    options
    |> list.map(fn(o) { #(o.name, o) })

  Subcommand(name:, description:, options:, handler:)
}

pub fn handle_interaction(
  commands: Dict(String, Command(_)),
  i: Interaction,
  state: _,
) {
  case i.data {
    interaction.ChatInput(data) ->
      case dict.get(commands, data.name), data.options {
        Ok(ChatInput(handler:, ..)), option_value.Values(v) ->
          handler(i, v, state) |> Ok
        Ok(Group(elements:, ..)), option_value.Group(g) ->
          handle_group_interaction(i, state, elements, g)
        _, _ -> Error(Nil)
      }
    interaction.User(data) ->
      case dict.get(commands, data.name) {
        Ok(User(_, handler:)) -> handler(i, state) |> Ok
        _ -> Error(Nil)
      }
    interaction.Message(data) ->
      case dict.get(commands, data.name) {
        Ok(Message(_, handler:)) -> handler(i, state) |> Ok
        _ -> Error(Nil)
      }
  }
}

fn handle_group_interaction(
  i: Interaction,
  state: _,
  elements: Dict(String, Element(_)),
  group: option_value.Group,
) {
  case group {
    option_value.SubcommandElement(invoked) ->
      case dict.get(elements, invoked.name) {
        Ok(SubcommandElement(s)) -> s.handler(i, invoked.options, state) |> Ok
        _ -> Error(Nil)
      }
    option_value.GroupElement(name:, subcommand:) ->
      case dict.get(elements, name) {
        Ok(GroupElement(subcommands:, ..)) ->
          case dict.get(subcommands, subcommand.name) {
            Ok(s) -> s.handler(i, subcommand.options, state) |> Ok
            _ -> Error(Nil)
          }
        _ -> Error(Nil)
      }
  }
}

pub fn handle_autocomplete_interaction(
  commands: Dict(String, Command(_)),
  i: Interaction,
  state: _,
) {
  case i.data {
    interaction.ChatInput(data) ->
      case dict.get(commands, data.name), data.options {
        Ok(ChatInput(options:, ..)), option_value.Values(values) ->
          options_autocomplete(options, i, values, state)
        Ok(Group(elements:, ..)), option_value.Group(g) ->
          handle_group_autocomplete_interaction(g, elements, i, state)
        _, _ -> Error(Nil)
      }
    _ -> Error(Nil)
  }
}

fn handle_group_autocomplete_interaction(
  g: option_value.Group,
  elements: Dict(String, Element(_)),
  i: Interaction,
  state: _,
) -> Result(AutocompleteResponse, Nil) {
  case g {
    option_value.SubcommandElement(invoked) ->
      case dict.get(elements, invoked.name) {
        Ok(SubcommandElement(s)) ->
          options_autocomplete(s.options, i, invoked.options, state)
        _ -> Error(Nil)
      }
    option_value.GroupElement(name:, subcommand:) ->
      case dict.get(elements, name) {
        Ok(GroupElement(subcommands:, ..)) ->
          case dict.get(subcommands, subcommand.name) {
            Ok(Subcommand(options:, ..)) ->
              options_autocomplete(options, i, subcommand.options, state)
            _ -> Error(Nil)
          }
        _ -> Error(Nil)
      }
  }
}

fn options_autocomplete(
  options: List(#(String, Option(_))),
  i: Interaction,
  values: Dict(String, option_value.Value),
  state: _,
) -> Result(AutocompleteResponse, Nil) {
  let assert Ok(focused) = dict.values(values) |> option_value.find_focused
  case list.key_find(options, focused.name), focused {
    Ok(StringAutocompleteOption(autocomplete:, ..)),
      option_value.StringValue(value:, ..)
    ->
      autocomplete(i, values, value, state)
      |> StringAutocompleteResponse
      |> Ok
    Ok(IntegerAutocompleteOption(autocomplete:, ..)),
      option_value.IntegerValue(value:, ..)
    ->
      autocomplete(i, values, value, state)
      |> IntegerAutocompleteResponse
      |> Ok
    Ok(NumberAutocompleteOption(autocomplete:, ..)),
      option_value.NumberValue(value:, ..)
    ->
      autocomplete(i, values, value, state)
      |> NumberAutocompleteResponse
      |> Ok
    _, _ -> Error(Nil)
  }
}
