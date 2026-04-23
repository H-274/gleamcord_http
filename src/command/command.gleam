import command/interaction.{type Interaction}
import command/option_value
import command/response.{type Response}
import gleam/dict.{type Dict}
import gleam/json
import gleam/list

pub opaque type Command(state) {
  ChatInputCommand(ChatInput(state))
  ChatInputGroup(signature: Signature, sub: Dict(String, Subcommand(state)))
  User(signature: Signature, handler: UserHandler(state))
  Message(signature: Signature, handler: MessageHandler(state))
}

pub fn chat_input_command(chat_input: ChatInput(_)) {
  ChatInputCommand(chat_input)
}

pub fn chat_input_group(sig signature: Signature, sub sub: List(Subcommand(_))) {
  let sub =
    list.map(sub, fn(s) { #(s.name, s) })
    |> dict.from_list

  ChatInputGroup(signature:, sub:)
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
    integrations: List(Integration),
    contexts: List(Context),
    nsfw: Bool,
  )
}

pub type Integration {
  GuildInstall
  UserInstall
}

pub type Context {
  Guild
  BotDM
  PrivateChannel
}

pub fn simple_signature(name name: String, desc description: String) {
  Signature(
    name:,
    description:,
    default_member_permissions: "",
    integrations: [],
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
    max_val: Int,
    autocomplete: fn(Interaction, state, Int, option_value.Values) ->
      List(#(String, Int)),
    required: Bool,
  )
  BooleanOption(name: String, description: String, required: Bool)
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
    sub: Dict(String, Subcommand(state)),
  )
  Subcommand(
    name: String,
    description: String,
    options: Dict(String, CommandOption(state)),
    handler: ChatInputHandler(state),
  )
}

pub fn subcommand_group(
  name name: String,
  desc description: String,
  sub sub: List(Subcommand(_)),
) {
  let sub =
    list.map(sub, fn(s) { #(s.name, s) })
    |> dict.from_list

  SubcommandGroup(name:, description:, sub:)
}

pub fn subcommand(chat_input: ChatInput(_)) {
  let Signature(name:, description:, ..) = chat_input.signature
  Subcommand(
    name:,
    description:,
    options: chat_input.options,
    handler: chat_input.handler,
  )
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
        Ok(Subcommand(handler:, ..)) -> handler(i, state, invoked.options) |> Ok
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
  subcommands: Dict(String, Subcommand(state)),
  i: Interaction,
  state: state,
  invoked: option_value.Subcommand,
) {
  case dict.get(subcommands, invoked.name) {
    Ok(Subcommand(handler:, ..)) -> handler(i, state, invoked.options) |> Ok
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
          run_options_autocomplete(command.options, i, state, values)
        Ok(ChatInputGroup(sub:, ..)), option_value.Group(group) ->
          run_chat_input_group_autocomplete(sub, i, state, group)
        _, _ -> Error(Nil)
      }
    _ -> Error(Nil)
  }
}

fn run_options_autocomplete(
  options: Dict(String, CommandOption(state)),
  i: interaction.Interaction,
  state: state,
  values: option_value.Values,
) -> Result(response.AutocompleteResponse, Nil) {
  let assert Ok(option) = dict.values(values) |> list.find(fn(o) { o.focused })
    as "there should always be a focused option when autocomplete is called"

  case dict.get(options, option.name), option {
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
        Ok(Subcommand(options:, ..)) ->
          run_options_autocomplete(options, i, state, invoked.options)
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
  group_subcommands: Dict(String, Subcommand(state)),
  i: Interaction,
  state: state,
  invoked: option_value.Subcommand,
) -> Result(response.AutocompleteResponse, Nil) {
  case dict.get(group_subcommands, invoked.name) {
    Ok(Subcommand(options:, ..)) ->
      run_options_autocomplete(options, i, state, invoked.options)
    _ -> Error(Nil)
  }
}

/// Encoding
///
/// TODO review subcommand groups to avoid setting unnecessary data
/// TODO review to ensure option order is maintained when encoding
pub fn json(command: Command(_)) {
  case command {
    ChatInputCommand(c) -> chat_input_json(c)
    ChatInputGroup(signature:, sub:) -> chat_input_group_json(signature, sub)
    User(signature:, ..) -> user_json(signature)
    Message(signature:, ..) -> message_json(signature)
  }
}

fn chat_input_json(command: ChatInput(_)) {
  let Signature(
    name:,
    description:,
    default_member_permissions:,
    integrations:,
    contexts:,
    nsfw:,
  ) = command.signature
  json.object([
    #("name", json.string(name)),
    #("description", json.string(description)),
    #("options", options_json(command.options)),
    #("default_member_permissions", json.string(default_member_permissions)),
    #("integration_types", integrations_json(integrations)),
    #("contexts", contexts_json(contexts)),
    #("type", json.int(1)),
    #("nsfw", json.bool(nsfw)),
  ])
}

fn chat_input_group_json(signature: Signature, sub: Dict(String, Subcommand(_))) {
  let Signature(
    name:,
    description:,
    default_member_permissions:,
    integrations:,
    contexts:,
    nsfw:,
  ) = signature
  json.object([
    #("name", json.string(name)),
    #("description", json.string(description)),
    #("options", subcommand_json(sub)),
    #("default_member_permissions", json.string(default_member_permissions)),
    #("integration_types", integrations_json(integrations)),
    #("contexts", contexts_json(contexts)),
    #("type", json.int(1)),
    #("nsfw", json.bool(nsfw)),
  ])
}

fn subcommand_json(sub: Dict(String, Subcommand(_))) {
  let subcommands = dict.values(sub)

  use sub <- json.array(subcommands)
  case sub {
    SubcommandGroup(name:, description:, sub:) -> {
      json.object([
        #("type", json.int(2)),
        #("name", json.string(name)),
        #("description", json.string(description)),
        #("options", subcommand_json(sub)),
      ])
    }
    Subcommand(name:, description:, options:, ..) ->
      json.object([
        #("type", json.int(1)),
        #("name", json.string(name)),
        #("description", json.string(description)),
        #("options", options_json(options)),
      ])
  }
}

fn user_json(signature: Signature) {
  let Signature(
    name:,
    description:,
    default_member_permissions:,
    integrations:,
    contexts:,
    nsfw:,
  ) = signature
  json.object([
    #("name", json.string(name)),
    #("description", json.string(description)),
    #("default_member_permissions", json.string(default_member_permissions)),
    #("integration_types", integrations_json(integrations)),
    #("contexts", contexts_json(contexts)),
    #("type", json.int(2)),
    #("nsfw", json.bool(nsfw)),
  ])
}

fn message_json(signature: Signature) {
  let Signature(
    name:,
    description:,
    default_member_permissions:,
    integrations:,
    contexts:,
    nsfw:,
  ) = signature
  json.object([
    #("name", json.string(name)),
    #("description", json.string(description)),
    #("default_member_permissions", json.string(default_member_permissions)),
    #("integration_types", integrations_json(integrations)),
    #("contexts", contexts_json(contexts)),
    #("type", json.int(3)),
    #("nsfw", json.bool(nsfw)),
  ])
}

fn options_json(options: Dict(String, CommandOption(_))) {
  let options = dict.values(options)
  use opt <- json.array(options)
  case opt {
    StringOption(min_len:, max_len:, required:, ..) -> [
      #("type", json.int(3)),
      #("min_length", json.int(min_len)),
      #("max_length", json.int(max_len)),
      #("required", json.bool(required)),
    ]
    StringChoicesOption(choices:, required:, ..) -> [
      #("type", json.int(3)),
      #(
        "choices",
        json.array(choices, fn(c) {
          json.object([
            #("name", json.string(c.0)),
            #("value", json.string(c.1)),
          ])
        }),
      ),
      #("required", json.bool(required)),
    ]
    StringAutocompleteOption(min_len:, max_len:, autocomplete: _, required:, ..) -> [
      #("type", json.int(3)),
      #("min_length", json.int(min_len)),
      #("max_length", json.int(max_len)),
      #("autocomplete", json.bool(True)),
      #("required", json.bool(required)),
    ]
    IntegerOption(min_val:, max_val:, required:, ..) -> [
      #("type", json.int(4)),
      #("min_value", json.int(min_val)),
      #("max_value", json.int(max_val)),
      #("required", json.bool(required)),
    ]
    IntegerChoicesOption(choices:, required:, ..) -> [
      #("type", json.int(4)),
      #(
        "choices",
        json.array(choices, fn(c) {
          json.object([#("name", json.string(c.0)), #("value", json.int(c.1))])
        }),
      ),
      #("required", json.bool(required)),
    ]
    IntegerAutocompleteOption(
      min_val:,
      max_val:,
      autocomplete: _,
      required:,
      ..,
    ) -> [
      #("type", json.int(4)),
      #("min_value", json.int(min_val)),
      #("max_value", json.int(max_val)),
      #("autocomplete", json.bool(True)),
      #("required", json.bool(required)),
    ]
    BooleanOption(required:, ..) -> [
      #("type", json.int(5)),
      #("required", json.bool(required)),
    ]
    UserOption(required:, ..) -> [
      #("type", json.int(6)),
      #("required", json.bool(required)),
    ]
    ChannelOption(channel_types:, required:, ..) -> [
      #("type", json.int(7)),
      #("channel_types", json.array(channel_types, fn(_t) { json.object([]) })),
      #("required", json.bool(required)),
    ]
    RoleOption(required:, ..) -> [
      #("type", json.int(8)),
      #("required", json.bool(required)),
    ]
    MentionableOption(required:, ..) -> [
      #("type", json.int(9)),
      #("required", json.bool(required)),
    ]
    NumberOption(min_val:, max_val:, required:, ..) -> [
      #("type", json.int(10)),
      #("min_value", json.float(min_val)),
      #("max_length", json.float(max_val)),
      #("required", json.bool(required)),
    ]
    NumberChoicesOption(choices:, required:, ..) -> [
      #("type", json.int(10)),
      #(
        "choices",
        json.array(choices, fn(c) {
          json.object([#("name", json.string(c.0)), #("value", json.float(c.1))])
        }),
      ),
      #("required", json.bool(required)),
    ]
    NumberAutocompleteOption(min_val:, max_val:, autocomplete: _, required:, ..) -> [
      #("type", json.int(10)),
      #("min_value", json.float(min_val)),
      #("max_length", json.float(max_val)),
      #("autocomplete", json.bool(True)),
      #("required", json.bool(required)),
    ]
    AttachmentOption(required:, ..) -> [
      #("type", json.int(11)),
      #("required", json.bool(required)),
    ]
  }
  |> list.append([
    #("name", json.string(opt.name)),
    #("description", json.string(opt.description)),
  ])
  |> json.object
}

fn integrations_json(integrations: List(Integration)) {
  use i <- json.array(integrations)
  case i {
    GuildInstall -> json.int(0)
    UserInstall -> json.int(1)
  }
}

pub fn contexts_json(contexts: List(Context)) {
  use c <- json.array(contexts)
  case c {
    Guild -> json.int(0)
    BotDM -> json.int(1)
    PrivateChannel -> json.int(2)
  }
}
