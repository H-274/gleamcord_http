import command/interaction.{type Interaction}
import command/option_value
import command/response.{type Response}
import gleam/dict.{type Dict}
import gleam/list

pub opaque type Command(state) {
  ChatInputCommand(ChatInput(state))
  ChatInputGroup(
    name: String,
    description: String,
    sub: Dict(String, Subcommand(state)),
  )
  User(signature: Signature, handler: UserHandler(state))
  Message(signature: Signature, handler: MessageHandler(state))
}

pub fn chat_input_command(chat_input: ChatInput(_)) {
  ChatInputCommand(chat_input)
}

pub fn chat_input_group(
  name name: String,
  desc description: String,
  sub sub: List(Subcommand(_)),
) {
  let sub =
    list.map(sub, fn(s) {
      case s {
        Subcommand(ChatInput(signature:, ..)) -> #(signature.name, s)
        SubcommandGroup(name:, ..) -> #(name, s)
      }
    })
    |> dict.from_list

  ChatInputGroup(name:, description:, sub:)
}

pub fn user(sig signature: Signature, handler handler: UserHandler(_)) {
  User(signature:, handler:)
}

pub fn message(sig signature: Signature, handler handler: MessageHandler(_)) {
  Message(signature:, handler:)
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

pub opaque type ChatInput(state) {
  ChatInput(
    signature: Signature,
    options: Dict(String, CommandOption(state)),
    handler: ChatInputHandler(state),
  )
}

pub fn chat_input(
  sig signature: Signature,
  opts options: List(CommandOption(state)),
  handler handler: ChatInputHandler(state),
) {
  let options = list.map(options, fn(o) { #(o.name, o) }) |> dict.from_list

  ChatInput(signature:, options:, handler:)
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
    autocomplete: fn(Interaction, state, String, option_value.Values) ->
      List(#(String, String)),
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
    autocomplete: fn(Interaction, state, Int, option_value.Values) ->
      List(#(String, Int)),
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
    autocomplete: fn(Interaction, state, Float, option_value.Values) ->
      List(#(String, Float)),
    required: Bool,
  )
  AttachmentOption(name: String, description: String, required: Bool)
}

pub type ChatInputHandler(state) =
  fn(Interaction, state, option_value.Values) -> Response(state)

pub fn find_focused_option(options: option_value.Values) {
  dict.values(options)
  |> list.find(fn(opt) { opt.focused })
}

pub opaque type Subcommand(state) {
  SubcommandGroup(
    name: String,
    description: String,
    sub: Dict(String, ChatInput(state)),
  )
  Subcommand(ChatInput(state))
}

pub fn subcommand_group(
  name name: String,
  desc description: String,
  sub sub: List(ChatInput(_)),
) {
  let sub = list.map(sub, fn(c) { #(c.signature.name, c) }) |> dict.from_list

  SubcommandGroup(name:, description:, sub:)
}

pub fn subcommand(chat_input: ChatInput(_)) {
  Subcommand(chat_input)
}

pub type UserHandler(state) =
  fn(Interaction, state) -> Response(state)

pub type MessageHandler(state) =
  fn(Interaction, state) -> Response(state)

pub fn run(
  commands: Dict(String, Command(state)),
  state: state,
  i: Interaction,
) -> Result(Response(state), Nil) {
  case i.data {
    interaction.ChatInput(chat_input) ->
      case dict.get(commands, chat_input.name), chat_input.options {
        Ok(ChatInputCommand(chat_input)), option_value.Values(values) ->
          chat_input.handler(i, state, values) |> Ok
        Ok(ChatInputGroup(sub:, ..)), option_value.Group(group) ->
          run_chat_input_group(sub, i, state, group)
        _, _ -> Error(Nil)
      }
    interaction.User(user) ->
      case dict.get(commands, user.name) {
        Ok(User(handler:, ..)) -> handler(i, state) |> Ok
        _ -> Error(Nil)
      }
    interaction.Message(message) ->
      case dict.get(commands, message.name) {
        Ok(Message(handler:, ..)) -> handler(i, state) |> Ok
        _ -> Error(Nil)
      }
  }
}

fn run_chat_input_group(
  subcommands: Dict(String, Subcommand(state)),
  i: Interaction,
  state: state,
  group: option_value.Group,
) -> Result(Response(state), Nil) {
  case group {
    option_value.Subcommand(invoked) ->
      case dict.get(subcommands, invoked.name) {
        Ok(Subcommand(chat_input)) ->
          chat_input.handler(i, state, invoked.options) |> Ok
        _ -> Error(Nil)
      }
    option_value.SubcommandGroup(invoked) ->
      case dict.get(subcommands, invoked.name) {
        Ok(SubcommandGroup(sub:, ..)) ->
          run_subcommand_group(sub, i, state, invoked.sub)
        _ -> Error(Nil)
      }
  }
}

fn run_subcommand_group(
  subcommands: Dict(String, ChatInput(state)),
  i: Interaction,
  state: state,
  invoked: option_value.Subcommand,
) {
  case dict.get(subcommands, invoked.name) {
    Ok(chat_input) -> chat_input.handler(i, state, invoked.options) |> Ok
    _ -> Error(Nil)
  }
}

pub fn run_autocomplete(
  commands: Dict(String, Command(state)),
  i: Interaction,
  state: state,
) -> Result(response.AutocompleteResponse, Nil) {
  case i.data {
    interaction.ChatInput(chat_input) ->
      case dict.get(commands, chat_input.name), chat_input.options {
        Ok(ChatInputCommand(command)), option_value.Values(values) ->
          run_chat_input_autocomplete(command, i, state, values)
        Ok(ChatInputGroup(sub:, ..)), option_value.Group(group) ->
          run_chat_input_group_autocomplete(sub, i, state, group)
        _, _ -> Error(Nil)
      }
    _ -> Error(Nil)
  }
}

fn run_chat_input_autocomplete(
  chat_input: ChatInput(state),
  i: interaction.Interaction,
  state: state,
  values: option_value.Values,
) -> Result(response.AutocompleteResponse, Nil) {
  let assert Ok(option) = dict.values(values) |> list.find(fn(o) { o.focused })
    as "there should always be a focused option when autocomplete is called"

  case dict.get(chat_input.options, option.name), option {
    Ok(StringAutocompleteOption(autocomplete: autocomplete, ..)),
      option_value.String(value: partial, ..)
    ->
      autocomplete(i, state, partial, values)
      |> response.StringAutocomplete
      |> Ok
    Ok(IntegerAutocompleteOption(autocomplete:, ..)),
      option_value.Integer(value: partial, ..)
    ->
      autocomplete(i, state, partial, values)
      |> response.IntegerAutocomplete
      |> Ok
    Ok(NumberAutocompleteOption(autocomplete:, ..)),
      option_value.Number(value: partial, ..)
    ->
      autocomplete(i, state, partial, values)
      |> response.NumberAutocomplete
      |> Ok
    _, _ -> Error(Nil)
  }
}

fn run_chat_input_group_autocomplete(
  sub: Dict(String, Subcommand(state)),
  i: Interaction,
  state: state,
  group: option_value.Group,
) -> Result(response.AutocompleteResponse, Nil) {
  case group {
    option_value.Subcommand(invoked) ->
      case dict.get(sub, invoked.name) {
        Ok(Subcommand(chat_input)) ->
          run_chat_input_autocomplete(chat_input, i, state, invoked.options)
        _ -> Error(Nil)
      }
    option_value.SubcommandGroup(invoked) ->
      case dict.get(sub, invoked.name) {
        Ok(SubcommandGroup(sub:, ..)) ->
          run_subcommand_group_autocomplete(sub, i, state, invoked.sub)
        _ -> Error(Nil)
      }
  }
}

fn run_subcommand_group_autocomplete(
  group_subcommands: Dict(String, ChatInput(state)),
  i: Interaction,
  state: state,
  invoked: option_value.Subcommand,
) -> Result(response.AutocompleteResponse, Nil) {
  case dict.get(group_subcommands, invoked.name) {
    Ok(chat_input) ->
      run_chat_input_autocomplete(chat_input, i, state, invoked.options)
    _ -> Error(Nil)
  }
}
