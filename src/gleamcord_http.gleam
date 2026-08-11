import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/result

pub type Command {
  ChatCommand(
    def: CommandDefinition,
    options: List(CommandOptionDefinition),
    run: fn(Dynamic, Dict(String, Dynamic)) -> CommandResponse,
  )
  ChatCommandGroup(
    def: CommandDefinition,
    elements: List(ChatCommandGroupElement),
  )
  UserCommand(def: CommandDefinition, run: fn(Dynamic) -> CommandResponse)
  MessageCommand(def: CommandDefinition, run: fn(Dynamic) -> CommandResponse)
}

pub type CommandDefinition {
  CommandDefinition(
    name: String,
    description: String,
    default_member_permissions: String,
    integ_types: List(Int),
    contexts: List(Int),
    nsfw: Bool,
  )
}

pub fn simple_definition(name name: String, desc description: String) {
  CommandDefinition(
    name:,
    description:,
    default_member_permissions: "",
    integ_types: [1],
    contexts: [1],
    nsfw: False,
  )
}

pub type ChatCommandGroupElement {
  ChatSubCommandGroup(
    name: String,
    description: String,
    sub_commands: List(ChatInputSubCommand),
  )
  ChatGroupSubCommand(ChatInputSubCommand)
}

pub fn group_sub_command(
  name name: String,
  desc description: String,
  opts options: List(CommandOptionDefinition),
  run run: fn(Dynamic, Dict(String, Dynamic)) -> CommandResponse,
) {
  ChatInputSubCommand(name:, description:, options:, run:)
  |> ChatGroupSubCommand
}

pub type ChatInputSubCommand {
  ChatInputSubCommand(
    name: String,
    description: String,
    options: List(CommandOptionDefinition),
    run: fn(Dynamic, Dict(String, Dynamic)) -> CommandResponse,
  )
}

pub fn sub_command(
  name name: String,
  desc description: String,
  opts options: List(CommandOptionDefinition),
  run run: fn(Dynamic, Dict(String, Dynamic)) -> CommandResponse,
) {
  ChatInputSubCommand(name:, description:, options:, run:)
}

pub type CommandResponse {
  CommandMessageResponse(Nil)
  CommandDeferredMessageResponse(fn() -> Nil)
  CommandModalResponse(Nil)
}

pub type CommandOptionDefinition {
  StringOption(
    name: String,
    description: String,
    min_len: Int,
    max_len: Int,
    required: Bool,
  )
  StringChoiceOption(
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
    required: Bool,
    run: fn(Dynamic, String) -> List(#(String, String)),
  )
  IntegerOption(
    name: String,
    description: String,
    min_value: Int,
    max_value: Int,
    required: Bool,
  )
  IntegerChoiceOption(
    name: String,
    description: String,
    choices: List(#(String, Int)),
    required: Bool,
  )
  IntegerAutocompleteOption(
    name: String,
    description: String,
    min_value: Int,
    max_value: Int,
    required: Bool,
    run: fn(Dynamic, Int) -> List(#(String, Int)),
  )
  BoooleanOption(name: String, description: String, required: Bool)
  UserOption(name: String, description: String, required: Bool)
  ChannelOption(
    name: String,
    description: String,
    channel_types: List(Int),
    required: Bool,
  )
  RoleOption(name: String, description: String, required: Bool)
  MentionableOption(name: String, description: String, required: Bool)
  NumberOption(
    name: String,
    description: String,
    min_value: Float,
    max_value: Float,
    required: Bool,
  )
  NumberChoiceOption(
    name: String,
    description: String,
    choices: List(#(String, Float)),
    required: Bool,
  )
  NumberAutocompleteOption(
    name: String,
    description: String,
    min_value: Float,
    max_value: Float,
    required: Bool,
    run: fn(Dynamic, Float) -> List(#(String, Float)),
  )
  AttachmentOption(name: String, description: String, required: Bool)
}

pub fn get_string_value(
  opts options: Dict(String, Dynamic),
  name name: String,
) {
  dict.get(options, name)
  |> result.replace_error([])
  |> result.map(decode.run(_, decode.string))
  |> result.flatten
}

pub fn get_integer_value(
  opts options: Dict(String, Dynamic),
  name name: String,
) {
  dict.get(options, name)
  |> result.replace_error([])
  |> result.map(decode.run(_, decode.int))
  |> result.flatten
}

pub fn get_boolean_value(
  opts options: Dict(String, Dynamic),
  name name: String,
) {
  dict.get(options, name)
  |> result.replace_error([])
  |> result.map(decode.run(_, decode.bool))
  |> result.flatten
}

pub fn get_user_value(
  opts options: Dict(String, Dynamic),
  res resolved: Dynamic,
  name name: String,
) {
  use user_id <- result.try(
    dict.get(options, name)
    |> result.replace_error([])
    |> result.map(decode.run(_, decode.string))
    |> result.flatten,
  )
  decode.run(resolved, decode.at(["users", user_id], decode.dynamic))
}

pub fn get_channel_value(
  opts options: Dict(String, Dynamic),
  res resolved: Dynamic,
  name name: String,
) {
  use channel_id <- result.try(
    dict.get(options, name)
    |> result.replace_error([])
    |> result.map(decode.run(_, decode.string))
    |> result.flatten,
  )

  decode.run(resolved, decode.at(["channels", channel_id], decode.dynamic))
}

pub fn get_role_value(
  opts options: Dict(String, Dynamic),
  res resolved: Dynamic,
  name name: String,
) {
  use role_id <- result.try(
    dict.get(options, name)
    |> result.replace_error([])
    |> result.map(decode.run(_, decode.string))
    |> result.flatten,
  )

  decode.run(resolved, decode.at(["channels", role_id], decode.dynamic))
}

pub fn get_mention_value(
  opts options: Dict(String, Dynamic),
  res resolved: Dynamic,
  name name: String,
) {
  use mention_id <- result.try(
    dict.get(options, name)
    |> result.replace_error([])
    |> result.map(decode.run(_, decode.string))
    |> result.flatten,
  )

  let role =
    decode.run(resolved, decode.at(["roles", mention_id], decode.dynamic))
  let users =
    decode.run(resolved, decode.at(["users", mention_id], decode.dynamic))

  result.or(role, users)
}

pub fn get_number_value(
  opts options: Dict(String, Dynamic),
  name name: String,
) {
  dict.get(options, name)
  |> result.replace_error([])
  |> result.map(decode.run(_, decode.float))
  |> result.flatten
}

pub fn get_attachment_value(
  opts options: Dict(String, Dynamic),
  res resolved: Dynamic,
  name name: String,
) {
  use attachment_id <- result.try(
    dict.get(options, name)
    |> result.replace_error([])
    |> result.map(decode.run(_, decode.string))
    |> result.flatten,
  )

  decode.run(
    resolved,
    decode.at(["attachments", attachment_id], decode.dynamic),
  )
}
