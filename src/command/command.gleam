import command/interaction.{type Interaction}
import command/response.{type Response}
import gleam/dict.{type Dict}
import gleam/list

pub type Command(state) {
  ChatInputCommand(ChatInput(state))
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

pub type ChatInput(state) {
  ChatInput(
    signature: Signature,
    options: List(CommandOption(state)),
    handler: ChatInputHandler(state),
  )
}

pub type CommandOption(state) {
  StringOption(
    name: String,
    description: String,
    min_len: Int,
    max_len: Int,
    required: Bool,
  )
  StringChoicesOption(
    name: String,
    description: String,
    choices: List(#(String, String)),
    required: Bool,
  )
  StringAutocompleteOption(
    name: String,
    description: String,
    min_len: Int,
    max_len: Int,
    autocomplete: fn(Interaction, state, String) -> List(#(String, String)),
    required: Bool,
  )
  IntegerOption(
    name: String,
    description: String,
    min_val: Int,
    max_val: Int,
    required: Bool,
  )
  IntegerChoicesOption(
    name: String,
    description: String,
    choices: List(#(String, Int)),
    required: Bool,
  )
  IntegerAutocompleteOption(
    name: String,
    description: String,
    min_val: Int,
    max_value: Int,
    autocomplete: fn(Interaction, state, Int) -> List(#(String, Int)),
    required: Bool,
  )
  UserOption(name: String, description: String, required: Bool)
  ChannelOption(
    name: String,
    description: String,
    // TODO define channel type
    channel_types: List(Nil),
    required: Bool,
  )
  RoleOption(name: String, description: String, required: Bool)
  MentionableOption(name: String, description: String, required: Bool)
  NumberOption(
    name: String,
    description: String,
    min_val: Float,
    max_val: Float,
    required: Bool,
  )
  NumberChoicesOption(
    name: String,
    description: String,
    choices: List(#(String, Float)),
    required: Bool,
  )
  NumberAutocompleteOption(
    name: String,
    description: String,
    min_val: Float,
    max_val: Float,
    autocomplete: fn(Interaction, state, Float) -> List(#(String, Float)),
    required: Bool,
  )
  AttachmentOption(name: String, description: String, required: Bool)
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

pub fn find_focused_option(options: Dict(String, OptionValue)) {
  dict.values(options)
  |> list.find(fn(opt) { opt.focused })
}

pub type Subcommand(state) {
  SubcommandGroup(
    name: String,
    description: String,
    sub: List(ChatInput(state)),
  )
  Subcommand(ChatInput(state))
}

pub type UserHandler(state) =
  fn(Interaction, state) -> Response(state)

pub type MessageHandler(state) =
  fn(Interaction, state) -> Response(state)
