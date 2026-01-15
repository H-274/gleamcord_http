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

pub opaque type CommandOption {
  StringOption(
    name: String,
    description: String,
    required: Bool,
    choices: Option(List(#(String, String))),
    min_length: Option(Int),
    max_length: Option(Int),
    autocomplete: Option(Autocomplete(String)),
  )
  IntegerOption(
    name: String,
    description: String,
    required: Bool,
    choices: Option(List(#(String, Int))),
    min_value: Option(Int),
    max_value: Option(Int),
    autocomplete: Option(Autocomplete(Int)),
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
    choices: Option(List(#(String, Float))),
    min_value: Option(Float),
    max_value: Option(Float),
    autocomplete: Option(Autocomplete(Float)),
  )
  AttachmentOption(name: String, description: String, required: Bool)
}

pub type Autocomplete(val) =
  fn(Nil, val) -> List(#(String, val))

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

pub fn min_length(option: CommandOption, min_length: Int) {
  assert min_string_length <= min_length
    as "`min_length` must be bigger than or equal to the minimum string length of 0"
  assert min_length <= max_string_length
    as "`min_length` must be less than or equal to the maximum string length of 6000"

  case option {
    StringOption(..) ->
      StringOption(..option, min_length: option.Some(min_length))

    _ -> panic as "Expected `option` to be of variant `StringOption`"
  }
}

pub fn max_length(option: CommandOption, max_length: Int) {
  assert { min_string_length + 1 } <= max_length
    as "`max_length` must be bigger than or equal to the minimum string length of 0, plus 1"
  assert max_length <= max_string_length
    as "`max_length` must be smaller than or equal to the maximum string length of 6000"

  case option {
    StringOption(..) ->
      StringOption(..option, max_length: option.Some(max_length))

    _ -> panic as "Expected `option` to be of variant `StringOption`"
  }
}

pub fn string_choices(option: CommandOption, choices: List(#(String, String))) {
  assert !list.is_empty(choices) as "Choices cannot be empty"

  case option {
    StringOption(autocomplete: autocomplete, ..) -> {
      assert option.is_none(autocomplete)
        as "An option cannot have choices if it uses autocomplete"
      StringOption(..option, choices: option.Some(choices))
    }

    _ -> panic as "Expected `option` to be of variant `StringOption`"
  }
}

pub fn string_autocomplete(
  option: CommandOption,
  autocomplete: Autocomplete(String),
) {
  case option {
    StringOption(choices: choices, ..) -> {
      assert option.is_none(choices)
        as "An option cannot have autocomplete if it uses choices"
      StringOption(..option, autocomplete: option.Some(autocomplete))
    }

    _ -> panic as "Expected `option` to be of variant `StringOption`"
  }
}

pub fn integer_min_value(option: CommandOption, min_value: Int) {
  assert min_integer_value <= min_value
    as "`min_value` must be bigger than or equal to the minimum integer value of -9_007_199_254_740_991"
  assert min_value <= max_integer_value
    as "`min_value` must be smaller than or equal to the maximum integer value of 9_007_199_254_740_991"

  case option {
    IntegerOption(..) ->
      IntegerOption(..option, min_value: option.Some(min_value))

    _ -> panic as "Expected `option` to be of variant `IntegerOption`"
  }
}

pub fn integer_max_value(option: CommandOption, max_value: Int) {
  assert min_integer_value <= max_value
    as "`max_value` must be bigger than or equal to the minimum integer value of -9_007_199_254_740_991, plus 1"
  assert max_value <= max_integer_value
    as "`max_value` must be smaller than or equal to the maximum integer value of 9_007_199_254_740_991"

  case option {
    IntegerOption(..) ->
      IntegerOption(..option, max_value: option.Some(max_value))

    _ -> panic as "Expected `option` to be of variant `IntegerOption`"
  }
}

pub fn integer_choices(option: CommandOption, choices: List(#(String, Int))) {
  assert !list.is_empty(choices) as "Choices cannot be empty"

  case option {
    IntegerOption(autocomplete: autocomplete, ..) -> {
      assert option.is_none(autocomplete)
        as "An option cannot have choices if it uses autocomplete"
      IntegerOption(..option, choices: option.Some(choices))
    }

    _ -> panic as "Expected `option` to be of variant `IntegerOption`"
  }
}

pub fn integer_autocomplete(
  option: CommandOption,
  autocomplete: Autocomplete(Int),
) {
  case option {
    IntegerOption(choices: choices, ..) -> {
      assert option.is_none(choices)
        as "An option cannot have autocomplete if it uses choices"
      IntegerOption(..option, autocomplete: option.Some(autocomplete))
    }

    _ -> panic as "Expected `option` to be of variant `IntegerOption`"
  }
}

pub fn number_min_value(option: CommandOption, min_value: Float) {
  assert min_number_value <=. min_value
    as "`min_value` must be bigger than or equal to the minimum integer value of -1.7976931348623157e308"
  assert min_value <=. max_number_value
    as "`min_value` must be bigger than or equal to the minimum integer value of 1.7976931348623157e308"

  case option {
    NumberOption(..) ->
      NumberOption(..option, min_value: option.Some(min_value))

    _ -> panic as "Expected `option` to be of variant `NumberOption`"
  }
}

pub fn number_max_value(option: CommandOption, max_value: Float) {
  assert min_number_value >=. max_value
    as "`max_value` must be bigger than or equal to the minimum integer value of -1.7976931348623157e308, plus 1"
  assert max_value <=. max_number_value
    as "`max_value` must be bigger than or equal to the minimum integer value of 1.7976931348623157e308"

  case option {
    NumberOption(..) ->
      NumberOption(..option, max_value: option.Some(max_value))

    _ -> panic as "Expected `option` to be of variant `NumberOption`"
  }
}

pub fn number_choices(option: CommandOption, choices: List(#(String, Float))) {
  assert !list.is_empty(choices) as "Choices cannot be empty"

  case option {
    NumberOption(autocomplete: autocomplete, ..) -> {
      assert option.is_none(autocomplete)
        as "An option cannot have choices if it uses autocomplete"
      NumberOption(..option, choices: option.Some(choices))
    }

    _ -> panic as "Expected `option` to be of variant `NumberOption`"
  }
}

pub fn number_autocomplete(
  option: CommandOption,
  autocomplete: Autocomplete(Float),
) {
  case option {
    NumberOption(choices: choices, ..) -> {
      assert option.is_none(choices)
        as "An option cannot have autocomplete if it uses choices"
      NumberOption(..option, autocomplete: option.Some(autocomplete))
    }

    _ -> panic as "Expected `option` to be of variant `NumberOption`"
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
