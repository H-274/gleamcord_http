import command/interaction.{type Interaction}
import command/response.{type Response}
import gleam/dict.{type Dict}

pub type Command(state) {
  ChatInput(fn() -> ChatInputCommand(state))
  ChatInputGroup(
    name: String,
    description: String,
    sub: List(Subcommand(state)),
  )
  User(signature: Signature, handler: UserHandler(state))
  Message(signature: Signature, handler: MessageHandler(state))
}

pub type Signature {
  Signature(
    name: String,
    description: String,
    default_member_permissions: String,
    integration_types: List(Nil),
    contexts: List(Nil),
    nsfw: Bool,
  )
}

pub fn simple_signature(name name: String, desc description: String) {
  Signature(
    name:,
    description:,
    default_member_permissions: "",
    integration_types: [],
    contexts: [],
    nsfw: False,
  )
}

pub type ChatInputCommand(state) {
  ChatInputCommand(
    signature: Signature,
    options: List(CommandOption),
    handler: ChatInputHandler(state),
  )
}

pub type CommandOption {
  StringOption
  StringChoicesOption
  StringAutocompleteOption
  IntegerOption
  IntegerChoicesOption
  IntegerAutocompleteOption
  UserOption
  ChannelOption
  RoleOption
  MentionableOption
  NumberOption
  NumberChoicesOption
  NumberAutocompleteOption
  AttachmentOption
}

pub type ChatInputHandler(state) =
  fn(Interaction, state, Dict(String, OptionValue)) -> Response(state)

pub type OptionValue {
  StringValue(name: String, value: String, focused: Bool)
  IntegerValue(name: String, value: Int, focused: Bool)
  BooleanValue(name: String, value: Bool, focused: Bool)
  UserValue(name: String, value: String, focused: Bool)
  ChannelValue(name: String, value: String, focused: Bool)
  RoleValue(name: String, value: String, focused: Bool)
  MentionableValue(name: String, value: String, focused: Bool)
  NumberValue(name: String, value: Float, focused: Bool)
  AttachmentValue(name: String, value: String, focused: Bool)
}

pub type Subcommand(state) {
  SubcommandGroup(
    name: String,
    description: String,
    sub: List(ChatInputCommand(state)),
  )
  Subcommand(ChatInputCommand(state))
}

pub type UserHandler(state) =
  fn(Interaction, state) -> Response(state)

pub type MessageHandler(state) =
  fn(Interaction, state) -> Response(state)
