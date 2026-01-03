//// Based on:
//// - https://discord.com/developers/docs/interactions/application-commands#application-command-object

import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{type Option}
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
    ChatInputGroup(_, _, subcommands) ->
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
    ChatInputGroup(_, _, subcommands) ->
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

pub opaque type CommandOption {
  StringOption(
    name: String,
    description: String,
    required: Bool,
    choices: Option(List(String)),
    min_length: Option(Int),
    max_length: Option(Int),
    autocomplete: Option(Nil),
  )
  IntegerOption(
    name: String,
    description: String,
    required: Bool,
    choices: Option(List(Int)),
    min_value: Option(Int),
    max_value: Option(Int),
    autocomplete: Option(Nil),
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
    choices: Option(List(Float)),
    min_value: Option(Float),
    max_value: Option(Float),
    autocomplete: Option(Nil),
  )
  AttachmentOption(name: String, description: String, required: Bool)
}

pub fn string_option(name name: String, desc description: String) {
  StringOption(
    name:,
    description:,
    required: True,
    choices: option.None,
    min_length: option.None,
    max_length: option.None,
    autocomplete: option.None,
  )
}

pub fn integer_option(name name: String, desc description: String) {
  IntegerOption(
    name:,
    description:,
    required: True,
    choices: option.None,
    min_value: option.None,
    max_value: option.None,
    autocomplete: option.None,
  )
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

pub fn number_option(name name: String, desc description: String) {
  NumberOption(
    name:,
    description:,
    required: True,
    min_value: option.None,
    max_value: option.None,
    choices: option.None,
    autocomplete: option.None,
  )
}

pub fn attachment_option(name name: String, desc description: String) {
  AttachmentOption(name:, description:, required: True)
}

pub fn required(option: CommandOption, required: Bool) {
  case option {
    StringOption(_, _, _, _, _, _, _) -> StringOption(..option, required:)
    IntegerOption(_, _, _, _, _, _, _) -> IntegerOption(..option, required:)
    BooleanOption(_, _, _) -> BooleanOption(..option, required:)
    UserOption(_, _, _) -> UserOption(..option, required:)
    ChannelOption(_, _, _, _) -> ChannelOption(..option, required:)
    RoleOption(_, _, _) -> RoleOption(..option, required:)
    MentionableOption(_, _, _) -> MentionableOption(..option, required:)
    NumberOption(_, _, _, _, _, _, _) -> NumberOption(..option, required:)
    AttachmentOption(_, _, _) -> AttachmentOption(..option, required:)
  }
}

pub fn min_length(option: CommandOption, min_length: Int) {
  assert min_string_length <= min_length
    as "`min_length` must be bigger than or equal to the minimum string length of 0"
  assert min_length <= max_string_length
    as "`min_length` must be less than or equal to the maximum string length of 6000"

  case option {
    StringOption(_, _, _, _, _, _, _) ->
      StringOption(..option, min_length: option.Some(min_length))

    _ -> panic as "Expected `option` to be of value `StringOption`"
  }
}

pub fn max_length(option: CommandOption, max_length: Int) {
  assert { min_string_length + 1 } <= max_length
    as "`max_length` must be bigger than or equal to the minimum string length of 0, plus 1"
  assert max_length <= max_string_length
    as "`max_length` must be smaller than or equal to the maximum string length of 6000"

  case option {
    StringOption(_, _, _, _, _, _, _) ->
      StringOption(..option, max_length: option.Some(max_length))

    _ -> panic as "Expected `option` to be of value `StringOption`"
  }
}

pub fn string_choices(option: CommandOption, choices: List(String)) {
  assert !list.is_empty(choices) as "Choices cannot be empty"

  case option {
    StringOption(_, _, _, _, _, _, autocomplete) -> {
      assert option.is_none(autocomplete)
        as "An option cannot have choices if it uses autocomplete"
      StringOption(..option, choices: option.Some(choices))
    }

    _ -> panic as "Expected `option` to be of value `StringOption`"
  }
}

pub fn string_autocomplete(option: CommandOption, autocomplete: Nil) {
  case option {
    StringOption(_, _, _, choices, _, _, _) -> {
      assert option.is_none(choices)
        as "An option cannot have autocomplete if it uses choices"
      StringOption(..option, autocomplete: option.Some(autocomplete))
    }

    _ -> panic as "Expected `option` to be of value `StringOption`"
  }
}

pub fn integer_min_value(option: CommandOption, min_value: Int) {
  assert min_integer_value <= min_value
    as "`min_value` must be bigger than or equal to the minimum integer value of -9_007_199_254_740_991"
  assert min_value <= max_integer_value
    as "`min_value` must be smaller than or equal to the maximum integer value of 9_007_199_254_740_991"

  case option {
    IntegerOption(_, _, _, _, _, _, _) ->
      IntegerOption(..option, min_value: option.Some(min_value))

    _ -> panic as "Expected `option` to be of value `IntegerOption`"
  }
}

pub fn integer_max_value(option: CommandOption, max_value: Int) {
  assert min_integer_value <= max_value
    as "`max_value` must be bigger than or equal to the minimum integer value of -9_007_199_254_740_991, plus 1"
  assert max_value <= max_integer_value
    as "`max_value` must be smaller than or equal to the maximum integer value of 9_007_199_254_740_991"

  case option {
    IntegerOption(_, _, _, _, _, _, _) ->
      IntegerOption(..option, max_value: option.Some(max_value))

    _ -> panic as "Expected `option` to be of value `IntegerOption`"
  }
}

pub fn integer_choices(option: CommandOption, choices: List(Int)) {
  assert !list.is_empty(choices) as "Choices cannot be empty"

  case option {
    IntegerOption(_, _, _, _, _, _, autocomplete) -> {
      assert option.is_none(autocomplete)
        as "An option cannot have choices if it uses autocomplete"
      IntegerOption(..option, choices: option.Some(choices))
    }

    _ -> panic as "Expected `option` to be of value `IntegerOption`"
  }
}

pub fn integer_autocomplete(option: CommandOption, autocomplete: Nil) {
  case option {
    IntegerOption(_, _, _, choices, _, _, _) -> {
      assert option.is_none(choices)
        as "An option cannot have autocomplete if it uses choices"
      IntegerOption(..option, autocomplete: option.Some(autocomplete))
    }

    _ -> panic as "Expected `option` to be of value `IntegerOption`"
  }
}

pub fn number_min_value(option: CommandOption, min_value: Float) {
  assert min_number_value <=. min_value
    as "`min_value` must be bigger than or equal to the minimum integer value of -1.7976931348623157e308"
  assert min_value <=. max_number_value
    as "`min_value` must be bigger than or equal to the minimum integer value of 1.7976931348623157e308"

  case option {
    NumberOption(_, _, _, _, _, _, _) ->
      NumberOption(..option, min_value: option.Some(min_value))

    _ -> panic as "Expected `option` to be of value `NumberOption`"
  }
}

pub fn number_max_value(option: CommandOption, max_value: Float) {
  assert min_number_value >=. max_value
    as "`max_value` must be bigger than or equal to the minimum integer value of -1.7976931348623157e308, plus 1"
  assert max_value <=. max_number_value
    as "`max_value` must be bigger than or equal to the minimum integer value of 1.7976931348623157e308"

  case option {
    NumberOption(_, _, _, _, _, _, _) ->
      NumberOption(..option, max_value: option.Some(max_value))

    _ -> panic as "Expected `option` to be of value `NumberOption`"
  }
}

pub fn number_choices(option: CommandOption, choices: List(Float)) {
  assert !list.is_empty(choices) as "Choices cannot be empty"

  case option {
    NumberOption(_, _, _, _, _, _, autocomplete) -> {
      assert option.is_none(autocomplete)
        as "An option cannot have choices if it uses autocomplete"
      NumberOption(..option, choices: option.Some(choices))
    }

    _ -> panic as "Expected `option` to be of value `NumberOption`"
  }
}

pub fn number_autocomplete(option: CommandOption, autocomplete: Nil) {
  case option {
    NumberOption(_, _, _, choices, _, _, _) -> {
      assert option.is_none(choices)
        as "An option cannot have autocomplete if it uses choices"
      NumberOption(..option, autocomplete: option.Some(autocomplete))
    }

    _ -> panic as "Expected `option` to be of value `NumberOption`"
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
  fn(Nil, Dict(String, ChatInputOptionValue)) -> String

pub type ChatInputOptionValue {
  StringValue(value: String)
  IntegerValue(value: Int)
  BooleanValue(value: Bool)
  UserValue(value: Int)
  ChannelValue(value: Int)
  RoleValue(value: Int)
  MentionableValue(value: Int)
  NumberValue(value: Float)
  AttachmentValue(value: Int)
}

pub type UserHandler {
  UserHandler
}

pub type MessageHandler {
  MessageHandler
}
