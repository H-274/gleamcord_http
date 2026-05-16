import command/interaction.{type Interaction}
import gleam/dict.{type Dict}
import gleam/list
import message
import modal/modal

pub opaque type Command(state) {
  ChatInput(
    signature: Signature,
    options: List(#(String, Option)),
    handler: ChatInputHandler(state),
  )
  Group(signature: Signature, elements: Dict(String, GroupElement(state)))
  User(signature: Signature, handler: UserHandler(state))
  Message(signature: Signature, handler: MessageHandler(state))
}

pub fn to_tuple(command: Command(_)) {
  let key = case command {
    ChatInput(signature:, ..) -> todo
    Group(signature:, ..) -> todo
    User(signature:, ..) -> todo
    Message(signature:, ..) -> todo
  }

  #(key, command)
}

pub fn chat_input(
  sig signature: Signature,
  opts options: List(Option),
  handler handler: ChatInputHandler(_),
) {
  let options =
    options
    |> list.map(fn(o) { #(o.name, o) })

  ChatInput(signature:, options:, handler:)
}

pub fn group(
  sig signature: Signature,
  elements elements: List(GroupElement(_)),
) {
  let elements =
    elements
    |> list.map(fn(e) {
      case e {
        SubcommandGroup(name:, ..) -> #(name, e)
        SubcommandElement(_s) -> todo as "to tuple"
      }
    })
    |> dict.from_list

  Group(signature:, elements:)
}

pub fn user(sig signature: Signature, handler handler: UserHandler(_)) {
  User(signature:, handler:)
}

pub fn message(sig signature: Signature, handler handler: MessageHandler(_)) {
  Message(signature:, handler:)
}

/// TODO complete
pub type Signature {
  Signature
}

/// TODO complete
pub type Option {
  String(name: String)
  StringChoice(name: String)
  StringAutocomplete(name: String)
  Integer(name: String)
  IntegerChoice(name: String)
  IntegerAutocomplete(name: String)
}

pub type ChatInputHandler(state) =
  fn(Interaction, List(Nil), state) -> Response(state)

pub type UserHandler(state) =
  fn(Interaction, state) -> Response(state)

pub type MessageHandler(state) =
  fn(Interaction, state) -> Response(state)

pub type Response(state) {
  MessageResponse(message.New)
  DeferredMessageResponse(message.New)
  ModalResponse(modal.Modal(state))
}

pub type GroupElement(state) {
  SubcommandGroup(
    name: String,
    description: String,
    subcommands: Dict(String, Subcommand(state)),
  )
  SubcommandElement(Subcommand(state))
}

pub type Subcommand(state) {
  Subcommand(
    name: String,
    description: String,
    options: List(#(String, Nil)),
    handler: ChatInputHandler(state),
  )
}
