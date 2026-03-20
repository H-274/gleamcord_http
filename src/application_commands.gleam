//// Based on:
//// - https://discord.com/developers/docs/interactions/application-commands#application-command-object
//// 
//// TODO: Investigate merging chat input command and chat input subcommands to allow easily changing a subcommand to a command and vice-versa

import application_command/option_data
import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{type Option}
import interaction.{type Interaction}
import interaction/data
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
    subcommands: List(
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
  ChatInputGroup(name:, description:, subcommands: [])
}

pub fn add_subcommand_group(
  command: ApplicationCommand(state),
  subcommand_group: ChatInputSubcommandGroup(state),
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
  command: ApplicationCommand(state),
  subcommand: ChatInputSubcommand(state),
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
    subcommands: List(ChatInputSubcommand(state)),
  )
}

pub fn subcommand_group(
  name name: String,
  desc description: String,
  sub subcommands: List(ChatInputSubcommand(_)),
) {
  ChatInputSubcommandGroup(name:, description:, subcommands:)
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
  fn(Interaction, state, Dict(String, option_data.Value)) ->
    interaction.Response

pub type UserHandler(state) {
  UserHandler
}

pub type MessageHandler(state) {
  MessageHandler
}

pub fn execute_handler(
  commands: List(ApplicationCommand(state)),
  state: state,
  i: Interaction,
) -> Result(interaction.Response, Nil) {
  let assert interaction.ApplicationCommand(data:, ..) = i
  list.find_map(commands, fn(command) {
    case command, data {
      ChatInput(signature:, handler:, ..),
        data.ChatInputApplicationCommand(name:, ..)
        if signature.name == name
      -> {
        let assert type_utils.A(invoked_options) = data.options
        let invoked_options =
          invoked_options |> list.map(fn(o) { #(o.name, o) }) |> dict.from_list
        Ok(handler(i, state, invoked_options))
      }
      ChatInputGroup(name: group, subcommands:, ..),
        data.ChatInputApplicationCommand(name:, options:, ..)
        if group == name
      -> {
        let _ = #(subcommands, options)
        todo as "find subcommand"
      }
      User(signature:, handler:), data.UserApplicationCommand(name:, ..)
        if signature.name == name
      -> todo as "execute handler"
      Message(signature:, handler:), data.MessageApplicationCommand(name:, ..)
        if signature.name == name
      -> todo as "execute handler"
      _, _ -> Error(Nil)
    }
  })
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
    List(#(String, val))

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

pub fn find_execute_autocomplete(
  commands: List(ApplicationCommand(state)),
  state: state,
  i: Interaction,
) -> Result(interaction.Response, Nil) {
  let assert interaction.ApplicationCommandAutocomplete(data:, ..) = i

  use command <- list.find_map(commands)
  case command, data {
    ChatInput(signature:, options:, ..),
      data.ChatInputApplicationCommand(name:, options: invoked_options, ..)
      if signature.name == name
    -> {
      let assert type_utils.A(invoked_options) = invoked_options
      let assert Ok(focused) = list.find(invoked_options, fn(o) { o.focused })
      let invoked_options =
        list.map(invoked_options, fn(o) { #(o.name, o) })
        |> dict.from_list

      use option <- list.find_map(options)
      execute_autocomplete_option(option, focused, i, state, invoked_options)
    }
    ChatInputGroup(name: group, subcommands:, ..),
      data.ChatInputApplicationCommand(name:, options:, ..)
      if group == name
    -> {
      let assert type_utils.B(invoked_tree) = options
      let _ = #(subcommands, invoked_tree)
      todo as "drill to autocomplete subcommand option"
    }
    _, _ -> Error(Nil)
  }
}

fn execute_autocomplete_option(
  option: CommandOption(state),
  focused: option_data.Value,
  i: Interaction,
  state: state,
  invoked_options: Dict(String, option_data.Value),
) -> Result(interaction.Response, Nil) {
  case option {
    StringOption(
      name:,
      details: AutocompleteStringOption(autocomplete:, ..),
      ..,
    )
      if name == focused.name
    -> {
      let assert option_data.StringValue(value: partial, ..) = focused
      autocomplete(i, state, invoked_options, partial)
      |> interaction.StringAutocomplete
      |> Ok
    }
    IntegerOption(
      name:,
      details: AutocompleteIntegerOption(autocomplete:, ..),
      ..,
    )
      if name == focused.name
    -> {
      let assert option_data.IntegerValue(value: partial, ..) = focused
      autocomplete(i, state, invoked_options, partial)
      |> interaction.IntegerAutocomplete
      |> Ok
    }

    NumberOption(
      name:,
      details: AutocompleteNumberOption(autocomplete:, ..),
      ..,
    )
      if name == focused.name
    -> {
      let assert option_data.NumberValue(value: partial, ..) = focused
      autocomplete(i, state, invoked_options, partial)
      |> interaction.NumberAutocomplete
      |> Ok
    }

    _ -> Error(Nil)
  }
}
