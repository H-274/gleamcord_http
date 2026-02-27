//// Based on:
//// - https://discord.com/developers/docs/interactions/application-commands#application-command-object
//// 
//// TODO: Investigate merging chat input command and chat input subcommands to allow easily changing a subcommand to a command and vice-versa

import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{type Option}
import interaction.{type Interaction}
import internal/type_utils

pub opaque type AplicationCommand {
  ChatInput(
    signature: Signature,
    options: List(CommandOption),
    handler: ChatInputHandler,
  )
  ChatInputGroup(
    name: String,
    description: String,
    subcommands: List(
      type_utils.Or(ChatInputSubcommandGroup, ChatInputSubcommand),
    ),
  )
  User(signature: Signature, handler: UserHandler)
  Message(signature: Signature, handler: MessageHandler)
}

pub fn chat_input(
  signature signature: Signature,
  opts options: List(CommandOption),
  handler handler: ChatInputHandler,
) {
  ChatInput(signature:, options:, handler:)
}

pub fn chat_input_group(name name: String, desc description: String) {
  ChatInputGroup(name:, description:, subcommands: [])
}

pub fn add_subcommand_group(
  command: AplicationCommand,
  subcommand_group: ChatInputSubcommandGroup,
) {
  case command {
    ChatInputGroup(subcommands: subcommands, ..) ->
      ChatInputGroup(..command, subcommands: [
        type_utils.A(subcommand_group),
        ..subcommands
      ])
    _ -> command
  }
}

pub fn add_subcommand(
  command: AplicationCommand,
  subcommand: ChatInputSubcommand,
) {
  case command {
    ChatInputGroup(subcommands: subcommands, ..) ->
      ChatInputGroup(..command, subcommands: [
        type_utils.B(subcommand),
        ..subcommands
      ])
    _ -> command
  }
}

pub fn user(signature signature: Signature, handler handler: UserHandler) {
  User(signature:, handler:)
}

pub fn message(signature signature: Signature, handler handler: MessageHandler) {
  Message(signature:, handler:)
}

pub opaque type ChatInputSubcommandGroup {
  ChatInputSubcommandGroup(
    name: String,
    description: String,
    subcommands: List(ChatInputSubcommand),
  )
}

pub fn subcommand_group(
  name name: String,
  desc description: String,
  sub subcommands: List(ChatInputSubcommand),
) {
  ChatInputSubcommandGroup(name:, description:, subcommands:)
}

pub opaque type ChatInputSubcommand {
  ChatInputSubcommand(
    signature: Signature,
    options: List(CommandOption),
    handler: ChatInputHandler,
  )
}

pub fn subcommand(
  signature signature: Signature,
  opts options: List(CommandOption),
  handler handler: ChatInputHandler,
) {
  ChatInputSubcommand(signature:, options:, handler:)
}

pub opaque type Signature {
  Signature(
    name: String,
    description: String,
    permissions: Nil,
    integration_types: List(Nil),
    contexts: List(Nil),
    nsfw: Bool,
  )
}

pub fn signature(name name: String, desc description: String) {
  Signature(
    name:,
    description:,
    permissions: Nil,
    integration_types: [Nil],
    contexts: [Nil, Nil],
    nsfw: False,
  )
}

/// According to https://discord.com/developers/docs/interactions/application-commands#application-command-object-application-command-option-structure
const min_string_length = 0

/// According to https://discord.com/developers/docs/interactions/application-commands#application-command-object-application-command-option-structure
const max_string_length = 6000

/// According to https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MIN_SAFE_INTEGER
const min_integer_value = -9_007_199_254_740_991

/// According to https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MAX_SAFE_INTEGER
const max_integer_value = 9_007_199_254_740_991

/// According to https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MAX_VALUE
const min_number_value = -1.7976931348623157e308

/// According to https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MAX_VALUE
const max_number_value = 1.7976931348623157e308

/// According to https://docs.discord.com/developers/interactions/application-commands#application-command-object-application-command-option-structure
const max_choice_count = 25

pub opaque type CommandOption {
  StringOption(
    name: String,
    description: String,
    required: Bool,
    details: StringOptionDetails,
  )
  IntegerOption(
    name: String,
    description: String,
    required: Bool,
    details: IntegerOptionDetails,
  )
  BooleanOption(name: String, description: String, required: Bool)
  UserOption(name: String, description: String, required: Bool)
  ChannelOption(
    name: String,
    description: String,
    required: Bool,
    types: List(Nil),
  )
  RoleOption(name: String, description: String, required: Bool)
  MentionableOption(name: String, description: String, required: Bool)
  NumberOption(
    name: String,
    description: String,
    required: Bool,
    details: NumberOptionDetails,
  )
  AttachmentOption(name: String, description: String, required: Bool)
}

pub type StringOptionDetails {
  BasicStringOption
  LengthStringOption(min_length: Option(Int), max_length: Option(Int))
  ChoicesStringOption(choices: List(#(String, String)))
  AutocompleteStringOption(
    min_length: Option(Int),
    max_length: Option(Int),
    autocomplete: Autocomplete(String),
  )
}

/// TODO: revisit min_len max_len branching to reduce code duplication 
pub fn string_option(
  name name: String,
  desc description: String,
  details details: StringOptionDetails,
) -> CommandOption {
  case details {
    LengthStringOption(min_length:, max_length:)
    | AutocompleteStringOption(min_length:, max_length:, ..) ->
      case min_length, max_length {
        option.Some(min_length), option.Some(max_length) -> {
          assert min_length >= min_string_length
          assert max_length <= max_string_length
          StringOption(name:, description:, required: True, details:)
        }
        option.Some(min_length), _ -> {
          assert min_length >= min_string_length
          StringOption(name:, description:, required: True, details:)
        }
        _, option.Some(max_length) -> {
          assert max_length <= max_string_length
          StringOption(name:, description:, required: True, details:)
        }
        _, _ -> StringOption(name:, description:, required: True, details:)
      }
    ChoicesStringOption(choices:) -> {
      assert list.length(choices) <= max_choice_count
      StringOption(name:, description:, required: True, details:)
    }
    _ -> StringOption(name:, description:, required: True, details:)
  }
}

pub type IntegerOptionDetails {
  BasicIntegerOption
  ValueIntegerOption(min_value: Option(Int), max_value: Option(Int))
  ChoicesIntegerOption(choices: List(#(String, Int)))
  AutocompleteIntegerOption(
    min_value: Option(Int),
    max_value: Option(Int),
    autocomplete: Option(Autocomplete(Int)),
  )
}

pub fn integer_option(
  name name: String,
  desc description: String,
  details details: IntegerOptionDetails,
) -> CommandOption {
  case details {
    ValueIntegerOption(min_value:, max_value:)
    | AutocompleteIntegerOption(min_value:, max_value:, ..) ->
      case min_value, max_value {
        option.Some(min_value), option.Some(max_value) -> {
          assert min_value >= min_integer_value
          assert max_value <= max_integer_value
          IntegerOption(name:, description:, required: True, details:)
        }
        option.Some(min_value), _ -> {
          assert min_value >= min_integer_value
          IntegerOption(name:, description:, required: True, details:)
        }
        _, option.Some(max_value) -> {
          assert max_value <= max_integer_value
          IntegerOption(name:, description:, required: True, details:)
        }
        _, _ -> IntegerOption(name:, description:, required: True, details:)
      }
    ChoicesIntegerOption(choices:) -> {
      assert list.length(choices) <= max_choice_count
      IntegerOption(name:, description:, required: True, details:)
    }
    _ -> IntegerOption(name:, description:, required: True, details:)
  }
}

pub fn boolean_option(name name: String, desc description: String) {
  BooleanOption(name:, description:, required: True)
}

pub fn user_option(name name: String, desc description: String) {
  UserOption(name:, description:, required: True)
}

pub fn channel_option(
  name name: String,
  desc description: String,
  types types: List(Nil),
) {
  ChannelOption(name:, description:, required: True, types:)
}

pub fn role_option(name name: String, desc description: String) {
  RoleOption(name:, description:, required: True)
}

pub fn mentionable_option(name name: String, desc description: String) {
  MentionableOption(name:, description:, required: True)
}

pub type NumberOptionDetails {
  BasicNumberOption
  ValueNumberOption(min_value: Option(Float), max_value: Option(Float))
  ChoicesNumberOption(choices: List(#(String, Float)))
  AutocompleteNumberOption(
    min_value: Option(Float),
    max_value: Option(Float),
    autocomplete: Autocomplete(Float),
  )
}

pub fn number_option(
  name name: String,
  desc description: String,
  details details: NumberOptionDetails,
) {
  case details {
    ValueNumberOption(min_value:, max_value:)
    | AutocompleteNumberOption(min_value:, max_value:, ..) ->
      case min_value, max_value {
        option.Some(min_value), option.Some(max_value) -> {
          assert min_value >=. min_number_value
          assert max_value <=. max_number_value
          NumberOption(name:, description:, required: True, details:)
        }
        option.Some(min_value), _ -> {
          assert min_value >=. min_number_value
          NumberOption(name:, description:, required: True, details:)
        }
        _, option.Some(max_value) -> {
          assert max_value <=. max_number_value
          NumberOption(name:, description:, required: True, details:)
        }
        _, _ -> NumberOption(name:, description:, required: True, details:)
      }
    ChoicesNumberOption(choices:) -> {
      assert list.length(choices) <= max_choice_count
      NumberOption(name:, description:, required: True, details:)
    }
    _ -> NumberOption(name:, description:, required: True, details:)
  }
}

pub type Autocomplete(val) =
  fn(Interaction, val) -> List(#(String, val))

pub fn attachment_option(name name: String, desc description: String) {
  AttachmentOption(name:, description:, required: True)
}

pub fn required(option: CommandOption, required: Bool) {
  case option {
    StringOption(..) -> StringOption(..option, required:)
    IntegerOption(..) -> IntegerOption(..option, required:)
    BooleanOption(..) -> BooleanOption(..option, required:)
    UserOption(..) -> UserOption(..option, required:)
    ChannelOption(..) -> ChannelOption(..option, required:)
    RoleOption(..) -> RoleOption(..option, required:)
    MentionableOption(..) -> MentionableOption(..option, required:)
    NumberOption(..) -> NumberOption(..option, required:)
    AttachmentOption(..) -> AttachmentOption(..option, required:)
  }
}

pub fn set_permissions(signature: Signature, permissions: Nil) {
  Signature(..signature, permissions:)
}

pub fn set_integration_types(signature: Signature, integration_types: List(Nil)) {
  Signature(..signature, integration_types:)
}

pub fn set_contexts(signature: Signature, contexts: List(Nil)) {
  Signature(..signature, contexts:)
}

pub fn set_nsfw(signature: Signature, nsfw: Bool) {
  Signature(..signature, nsfw:)
}

pub type ChatInputHandler =
  fn(Interaction, Dict(String, ChatInputOptionValue)) -> String

pub type ChatInputOptionValue {
  StringValue(name: String, value: String, focused: Bool)
  IntegerValue(name: String, value: Int, focused: Bool)
  BooleanValue(name: String, value: Bool, focused: Bool)
  UserValue(name: String, value: Int, focused: Bool)
  ChannelValue(name: String, value: Int, focused: Bool)
  RoleValue(name: String, value: Int, focused: Bool)
  MentionableValue(name: String, value: Int, focused: Bool)
  NumberValue(name: String, value: Float, focused: Bool)
  AttachmentValue(name: String, value: Int, focused: Bool)
}

pub type UserHandler {
  UserHandler
}

pub type MessageHandler {
  MessageHandler
}
