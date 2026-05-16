import command/interaction.{type Interaction}
import command/option_value
import gleam/dict.{type Dict}
import gleam/list
import message
import modal/modal

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
  DeferredMessageResponse(message.New)
  ModalResponse(modal.Modal(state))
}

pub type AutocompleteHandler(state, t) =
  fn(Interaction, Dict(String, option_value.Value), t, state) ->
    List(#(String, t))

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
