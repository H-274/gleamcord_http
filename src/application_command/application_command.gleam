//// Based on:
//// - https://discord.com/developers/docs/interactions/application-commands#application-command-object
//// 
//// TODO: Investigate merging chat input command and chat input subcommands to allow easily changing a subcommand to a command and vice-versa

import application_command/option_data
import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{type Option}
import interaction/data
import interaction/interaction.{type Interaction}
import internal/type_utils

pub opaque type ApplicationCommand(state) {
  ChatInput(
    signature: Signature,
    options: List(CommandOption(state)),
    handler: ChatInputHandler(state),
  )
  ChatInputGroup(
    name: String,
    description: String,
    subcommands: Dict(
      String,
      type_utils.Or(ChatInputSubcommandGroup(state), ChatInputSubcommand(state)),
    ),
  )
  User(signature: Signature, handler: UserHandler(state))
  Message(signature: Signature, handler: MessageHandler(state))
}

pub fn chat_input(
  signature signature: Signature,
  opts options: List(CommandOption(state)),
  handler handler: ChatInputHandler(_),
) {
  ChatInput(signature:, options:, handler:)
}

pub fn chat_input_group(name name: String, desc description: String) {
  ChatInputGroup(name:, description:, subcommands: dict.new())
}

pub fn add_subcommand_group(
  command: ApplicationCommand(state),
  subcommand_group: ChatInputSubcommandGroup(state),
) {
  case command {
    ChatInputGroup(subcommands: subcommands, ..) ->
      ChatInputGroup(
        ..command,
        subcommands: dict.insert(
          subcommands,
          subcommand_group.name,
          type_utils.A(subcommand_group),
        ),
      )
    _ -> command
  }
}

pub fn add_subcommand(
  command: ApplicationCommand(state),
  subcommand: ChatInputSubcommand(state),
) {
  case command {
    ChatInputGroup(subcommands: subcommands, ..) ->
      ChatInputGroup(
        ..command,
        subcommands: dict.insert(
          subcommands,
          subcommand.signature.name,
          type_utils.B(subcommand),
        ),
      )
    _ -> command
  }
}

pub fn user(signature signature: Signature, handler handler: UserHandler(_)) {
  User(signature:, handler:)
}

pub fn message(
  signature signature: Signature,
  handler handler: MessageHandler(_),
) {
  Message(signature:, handler:)
}

pub opaque type ChatInputSubcommandGroup(state) {
  ChatInputSubcommandGroup(
    name: String,
    description: String,
    subcommands: Dict(String, ChatInputSubcommand(state)),
  )
}

pub fn subcommand_group(
  name name: String,
  desc description: String,
  sub subcommands: List(ChatInputSubcommand(_)),
) {
  list.map(subcommands, fn(s) { #(s.signature.name, s) })
  |> dict.from_list
  |> ChatInputSubcommandGroup(name:, description:, subcommands: _)
}

pub opaque type ChatInputSubcommand(state) {
  ChatInputSubcommand(
    signature: Signature,
    options: List(CommandOption(state)),
    handler: ChatInputHandler(state),
  )
}

pub fn subcommand(
  signature signature: Signature,
  opts options: List(CommandOption(state)),
  handler handler: ChatInputHandler(state),
) {
  ChatInputSubcommand(signature:, options:, handler:)
}

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

pub type ChatInputHandler(state) =
  fn(Interaction, state, Dict(String, option_data.Value)) -> Response

pub type UserHandler(state) =
  fn(Interaction, state) -> Response

pub type MessageHandler(state) =
  fn(Interaction, state) -> Response

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

pub opaque type CommandOption(state) {
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
  fn(Interaction, state, Dict(String, option_data.Value), val) ->
    AutocompleteResponse

pub fn attachment_option(name name: String, desc description: String) {
  AttachmentOption(name:, description:, required: True)
}

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

pub fn handle_interaction(
  commands: Dict(String, ApplicationCommand(state)),
  state: state,
  i: Interaction,
  data: data.ApplicationCommand,
) -> Result(Response, Nil) {
  case data {
    data.ChatInputApplicationCommand(name: ivk_name, options:, ..) ->
      case dict.get(commands, ivk_name), options {
        Ok(ChatInput(handler:, ..)), type_utils.A(options) ->
          handler(i, state, options) |> Ok
        Ok(ChatInputGroup(subcommands:, ..)), type_utils.B(option) ->
          case option {
            type_utils.A(ivk) ->
              case dict.get(subcommands, ivk.name) {
                Ok(type_utils.A(group)) ->
                  case dict.get(group.subcommands, ivk.subcommand.name) {
                    Ok(subcommand) ->
                      subcommand.handler(i, state, ivk.subcommand.options) |> Ok
                    _ -> Error(Nil)
                  }
                _ -> Error(Nil)
              }
            type_utils.B(invoked) ->
              case dict.get(subcommands, invoked.name) {
                Ok(type_utils.B(subcommand)) ->
                  subcommand.handler(i, state, invoked.options) |> Ok
                _ -> Error(Nil)
              }
          }
        _, _ -> Error(Nil)
      }
    data.UserApplicationCommand(name: ivk_name, ..) ->
      case dict.get(commands, ivk_name) {
        Ok(User(handler:, ..)) -> handler(i, state) |> Ok
        _ -> Error(Nil)
      }
    data.MessageApplicationCommand(name: ivk_name, ..) ->
      case dict.get(commands, ivk_name) {
        Ok(Message(handler:, ..)) -> handler(i, state) |> Ok
        _ -> Error(Nil)
      }
  }
}

pub type Response {
  MessageWithSource(String)
  DeferredMessageWithSource(String)
  Modal
}

pub type AutocompleteResponse {
  StringAutocomplete(List(#(String, String)))
  IntegerAutocomplete(List(#(String, Int)))
  NumberAutocomplete(List(#(String, Float)))
}
