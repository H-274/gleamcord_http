//// https://discord.com/developers/docs/interactions/application-commands#application-commands

import entities/integration.{type Integration}
import entities/interaction_context.{type InteractionContext}
import entities/locale.{type Locale}

pub opaque type Command {
  User(UserCommand, UserExecute)
  Message(MessageCommand, MessageExecute)
  Text(TextCommand, TextExecute)
  DeepGroup(DeepCommandGroup)
  Group(CommandGroup)
}

pub type UserCommand {
  UserCommand(
    name: String,
    name_locales: List(#(Locale, String)),
    integration_types: List(Integration),
    contexts: List(InteractionContext),
    nsfw: Bool,
  )
}

pub fn user_command(name: String) {
  UserCommand(
    name:,
    name_locales: [],
    integration_types: [],
    contexts: [],
    nsfw: False,
  )
}

pub fn user_name_locales(
  command: UserCommand,
  name_locales: List(#(Locale, String)),
) {
  UserCommand(..command, name_locales:)
}

pub fn user_integration_types(
  command: UserCommand,
  integration_types: List(Integration),
) {
  UserCommand(..command, integration_types:)
}

pub fn user_contexts(command: UserCommand, contexts: List(InteractionContext)) {
  UserCommand(..command, contexts:)
}

pub fn user_nsfw(command: UserCommand, nsfw: Bool) {
  UserCommand(..command, nsfw:)
}

pub fn user_execute(command: UserCommand, execute: UserExecute) {
  User(command, execute)
}

pub type MessageCommand {
  MessageCommand(
    name: String,
    name_locales: List(#(Locale, String)),
    integration_types: List(Integration),
    contexts: List(InteractionContext),
    nsfw: Bool,
  )
}

pub fn message_command(name: String) {
  MessageCommand(
    name:,
    name_locales: [],
    integration_types: [],
    contexts: [],
    nsfw: False,
  )
}

pub fn message_name_locales(
  command: MessageCommand,
  name_locales: List(#(Locale, String)),
) {
  MessageCommand(..command, name_locales:)
}

pub fn message_integration_types(
  command: MessageCommand,
  integration_types: List(Integration),
) {
  MessageCommand(..command, integration_types:)
}

pub fn message_contexts(
  command: MessageCommand,
  contexts: List(InteractionContext),
) {
  MessageCommand(..command, contexts:)
}

pub fn message_nsfw(command: MessageCommand, nsfw: Bool) {
  MessageCommand(..command, nsfw:)
}

pub fn message_execute(command: MessageCommand, execute: MessageExecute) {
  Message(command, execute)
}

pub opaque type TextCommand {
  TextCommand(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    options: List(Option),
    default_member_permissions: String,
    integration_types: List(Integration),
    contexts: List(InteractionContext),
    nsfw: Bool,
  )
}

pub fn text_command(
  name name: String,
  desc description: String,
  integ_types integration_types: List(Integration),
  contexts contexts: List(InteractionContext),
) {
  TextCommand(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    options: [],
    default_member_permissions: "",
    integration_types:,
    contexts:,
    nsfw: False,
  )
}

pub fn text_name_locales(
  command: TextCommand,
  name_locales: List(#(Locale, String)),
) {
  TextCommand(..command, name_locales:)
}

pub fn text_description_locales(
  command: TextCommand,
  description_locales: List(#(Locale, String)),
) {
  TextCommand(..command, description_locales:)
}

pub fn text_options(command: TextCommand, options: List(Option)) {
  TextCommand(..command, options:)
}

pub fn text_default_member_perms(
  command: TextCommand,
  default_member_permissions: String,
) {
  TextCommand(..command, default_member_permissions:)
}

pub fn text_nsfw(command: TextCommand, nsfw: Bool) {
  TextCommand(..command, nsfw:)
}

pub fn text_execute(command: TextCommand, execute: TextExecute) {
  Text(command, execute)
}

pub fn text_group_member(command: TextCommand, execute: TextExecute) {
  #(command, execute)
}

pub type DeepCommandGroup {
  DeepCommandGroup(
    name: String,
    name_locales: List(#(Locale, String)),
    subcommand_groups: List(CommandGroup),
  )
}

pub fn deep_command_group(name: String) {
  DeepCommandGroup(name:, name_locales: [], subcommand_groups: [])
}

pub fn deep_command_group_name_locales(
  deep_group: DeepCommandGroup,
  name_locales: List(#(Locale, String)),
) {
  DeepCommandGroup(..deep_group, name_locales:)
}

pub fn deep_command_group_subcommand_groups(
  deep_group: DeepCommandGroup,
  subcommand_groups: List(CommandGroup),
) {
  DeepGroup(DeepCommandGroup(..deep_group, subcommand_groups:))
}

pub opaque type CommandGroup {
  CommandGroup(
    name: String,
    name_locales: List(#(Locale, String)),
    subcommands: List(#(TextCommand, TextExecute)),
  )
}

pub fn command_group(name: String) {
  CommandGroup(name:, name_locales: [], subcommands: [])
}

pub fn command_group_name_locales(
  group: CommandGroup,
  name_locales: List(#(Locale, String)),
) {
  CommandGroup(..group, name_locales:)
}

pub fn command_group_subcommands(
  group: CommandGroup,
  subcommands: List(#(TextCommand, TextExecute)),
) {
  Group(CommandGroup(..group, subcommands:))
}

pub type Option {
  String
  Integer
  Boolean
  UserOption
  Channel
  Role
  Mentionable
  Number
  Attachment
}

/// TODO
pub type UserExecute =
  fn(String) -> String

/// TODO
pub type MessageExecute =
  fn(String) -> String

/// TODO
pub type TextExecute =
  fn(String) -> String
