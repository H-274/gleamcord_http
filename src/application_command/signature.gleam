//// Based on:
//// - https://discord.com/developers/docs/interactions/application-commands#application-command-object
//// - https://docs.discord.com/developers/interactions/application-commands#application-command-object-application-command-option-structure

import application_command/interaction
import application_command/option_value
import gleam/list
import gleam/option.{type Option}

pub type Signature {
  Signature(
    name: String,
    description: String,
    permissions: Nil,
    integration_types: List(Nil),
    contexts: List(Nil),
    nsfw: Bool,
  )
}

pub fn new(name name: String, desc description: String) {
  Signature(
    name:,
    description:,
    permissions: Nil,
    integration_types: [Nil],
    contexts: [Nil, Nil],
    nsfw: False,
  )
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

pub type CommandOption(state) {
  StringOption(
    name: String,
    description: String,
    required: Bool,
    details: StringOptionDetails(state),
  )
  IntegerOption(
    name: String,
    description: String,
    required: Bool,
    details: IntegerOptionDetails(state),
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
    details: NumberOptionDetails(state),
  )
  AttachmentOption(name: String, description: String, required: Bool)
}

pub type StringOptionDetails(state) {
  BasicStringOption
  LengthStringOption(min_length: Option(Int), max_length: Option(Int))
  ChoicesStringOption(choices: List(#(String, String)))
  AutocompleteStringOption(
    min_length: Option(Int),
    max_length: Option(Int),
    autocomplete: AutocompleteHandler(state, String),
  )
}

/// Shorthand constructor to create a string option definition.
/// 
/// By default, required is set to true. To override, use the following:
/// ```gleam
/// /// Where "o" is the option
/// required(o, False)
/// ```
/// 
/// TODO: revisit min_len max_len branching to reduce code duplication 
pub fn string_option(
  name name: String,
  desc description: String,
  details details: StringOptionDetails(state),
) -> CommandOption(state) {
  case details {
    LengthStringOption(min_length:, max_length:)
    | AutocompleteStringOption(min_length:, max_length:, ..) -> {
      case min_length {
        // TODO: Add panic message
        option.Some(v) if v < min_string_length -> panic
        _ -> Nil
      }
      case max_length {
        // TODO: Add panic message
        option.Some(v) if v > max_string_length -> panic
        _ -> Nil
      }

      StringOption(name:, description:, required: True, details:)
    }

    ChoicesStringOption(choices:) -> {
      assert list.length(choices) <= max_choice_count
      StringOption(name:, description:, required: True, details:)
    }

    _ -> StringOption(name:, description:, required: True, details:)
  }
}

pub type IntegerOptionDetails(state) {
  BasicIntegerOption
  ValueIntegerOption(min_value: Option(Int), max_value: Option(Int))
  ChoicesIntegerOption(choices: List(#(String, Int)))
  AutocompleteIntegerOption(
    min_value: Option(Int),
    max_value: Option(Int),
    autocomplete: AutocompleteHandler(state, Int),
  )
}

/// Shorthand constructor to create an integer option definition.
/// 
/// By default, required is set to true. To override, use the following:
/// ```gleam
/// /// Where "o" is the option
/// required(o, False)
/// ```
pub fn integer_option(
  name name: String,
  desc description: String,
  details details: IntegerOptionDetails(state),
) -> CommandOption(state) {
  case details {
    ValueIntegerOption(min_value:, max_value:)
    | AutocompleteIntegerOption(min_value:, max_value:, ..) -> {
      case min_value {
        // TODO: Add panic message
        option.Some(v) if v < min_integer_value -> panic
        _ -> Nil
      }
      case max_value {
        // TODO: Add panic message
        option.Some(v) if v > max_integer_value -> panic
        _ -> Nil
      }

      IntegerOption(name:, description:, required: True, details:)
    }

    ChoicesIntegerOption(choices:) -> {
      assert list.length(choices) <= max_choice_count
      IntegerOption(name:, description:, required: True, details:)
    }

    _ -> IntegerOption(name:, description:, required: True, details:)
  }
}

/// Shorthand constructor to create a boolean option definition.
/// 
/// By default, required is set to true. To override, use the following:
/// ```gleam
/// /// Where "o" is the option
/// required(o, False)
/// ```
pub fn boolean_option(name name: String, desc description: String) {
  BooleanOption(name:, description:, required: True)
}

/// Shorthand constructor to create a user option definition.
/// 
/// By default, required is set to true. To override, use the following:
/// ```gleam
/// /// Where "o" is the option
/// required(o, False)
/// ```
pub fn user_option(name name: String, desc description: String) {
  UserOption(name:, description:, required: True)
}

/// Shorthand constructor to create a channel option definition.
/// 
/// By default, required is set to true. To override, use the following:
/// ```gleam
/// /// Where "o" is the option
/// required(o, False)
/// ```
pub fn channel_option(
  name name: String,
  desc description: String,
  types types: List(Nil),
) {
  ChannelOption(name:, description:, required: True, types:)
}

/// Shorthand constructor to create a role option definition.
/// 
/// By default, required is set to true. To override, use the following:
/// ```gleam
/// /// Where "o" is the option
/// required(o, False)
/// ```
pub fn role_option(name name: String, desc description: String) {
  RoleOption(name:, description:, required: True)
}

/// Shorthand constructor to create a mentionnable option definition.
/// 
/// By default, required is set to true. To override, use the following:
/// ```gleam
/// /// Where "o" is the option
/// required(o, False)
/// ```
/// 
pub fn mentionable_option(name name: String, desc description: String) {
  MentionableOption(name:, description:, required: True)
}

pub type NumberOptionDetails(state) {
  BasicNumberOption
  ValueNumberOption(min_value: Option(Float), max_value: Option(Float))
  ChoicesNumberOption(choices: List(#(String, Float)))
  AutocompleteNumberOption(
    min_value: Option(Float),
    max_value: Option(Float),
    autocomplete: AutocompleteHandler(state, Float),
  )
}

/// Shorthand constructor to create a number option definition.
/// 
/// By default, required is set to true. To override, use the following:
/// ```gleam
/// /// Where "o" is the option
/// required(o, False)
/// ```
/// 
pub fn number_option(
  name name: String,
  desc description: String,
  details details: NumberOptionDetails(_),
) {
  case details {
    ValueNumberOption(min_value:, max_value:)
    | AutocompleteNumberOption(min_value:, max_value:, ..) -> {
      case min_value {
        // TODO: Add panic message
        option.Some(v) if v <. min_number_value -> panic
        _ -> Nil
      }
      case max_value {
        // TODO: Add panic message
        option.Some(v) if v >. max_number_value -> panic
        _ -> Nil
      }

      NumberOption(name:, description:, required: True, details:)
    }

    ChoicesNumberOption(choices:) -> {
      assert list.length(choices) <= max_choice_count
      NumberOption(name:, description:, required: True, details:)
    }

    _ -> NumberOption(name:, description:, required: True, details:)
  }
}

pub type AutocompleteHandler(state, val) =
  fn(interaction.Interaction, state, option_value.Values, val) ->
    List(#(String, val))

/// Shorthand constructor to create an attachment option definition.
/// 
/// By default, required is set to true. To override, use the following:
/// ```gleam
/// /// Where "o" is the option
/// required(o, False)
/// ```
/// 
pub fn attachment_option(name name: String, desc description: String) {
  AttachmentOption(name:, description:, required: True)
}

/// Changes the required attribute of a command option definition
pub fn required(option: CommandOption(_), required: Bool) {
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
