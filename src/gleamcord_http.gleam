import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleamcord_http/command_option.{type CommandOption}
import gleamcord_http/component

pub type Command {
  ChatCommand(
    def: CommandDefinition,
    options: List(CommandOption),
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
  opts options: List(CommandOption),
  run run: fn(Dynamic, Dict(String, Dynamic)) -> CommandResponse,
) {
  ChatInputSubCommand(name:, description:, options:, run:)
  |> ChatGroupSubCommand
}

pub type ChatInputSubCommand {
  ChatInputSubCommand(
    name: String,
    description: String,
    options: List(CommandOption),
    run: fn(Dynamic, Dict(String, Dynamic)) -> CommandResponse,
  )
}

pub fn sub_command(
  name name: String,
  desc description: String,
  opts options: List(CommandOption),
  run run: fn(Dynamic, Dict(String, Dynamic)) -> CommandResponse,
) {
  ChatInputSubCommand(name:, description:, options:, run:)
}

pub type CommandResponse {
  CommandMessageResponse(Nil)
  CommandDeferredMessageResponse(fn() -> Nil)
  CommandModalResponse(Nil)
}

pub type MessageComponent {
  ButtonMessageComponent(
    btn: component.CustomButton,
    run: fn(Dynamic) -> MessageComponentResponse,
  )
  StringSelectMessageComponent(
    select: component.StringSelect,
    run: fn(Dynamic, List(String)) -> MessageComponentResponse,
  )
  UserSelectMessageComponent(
    select: component.UserSelect,
    run: fn(Dynamic, List(Dynamic)) -> MessageComponentResponse,
  )
  RoleSelectMessageComponent(
    select: component.RoleSelect,
    run: fn(Dynamic, List(Dynamic)) -> MessageComponentResponse,
  )
  MentionableSelectMessageComponent(
    select: component.MentionableSelect,
    run: fn(Dynamic, List(Dynamic)) -> MessageComponentResponse,
  )
  ChannelSelectMessageComponent(
    select: component.ChannelSelect,
    run: fn(Dynamic, List(Dynamic)) -> MessageComponentResponse,
  )
}

pub type MessageComponentResponse {
  MessageComponentMessageResponse(Nil)
  MessageComponentDeferredMessageResponse(fn() -> Nil)
  MessageComponentMessageUpdate(Nil)
  MessageComponentDeferredMessageUpdate(fn() -> Nil)
  MessageComponentModalResponse(Nil)
}
