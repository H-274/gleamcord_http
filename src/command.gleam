//// https://discord.com/developers/docs/interactions/application-commands#application-commands

import entities/integration.{type Integration}
import entities/interaction_context.{type InteractionContext}
import entities/locale.{type Locale}

pub opaque type Command {
  User(UserCommand, UserExecute)
  Message(MessageCommand, MessageExecute)
  Text(TextCommand, TextExecute)
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

pub fn user_command(
  name name: String,
  integrations integration_types: List(Integration),
  contexts contexts: List(InteractionContext),
) {
  UserCommand(
    name:,
    name_locales: [],
    integration_types:,
    contexts:,
    nsfw: False,
  )
}

pub fn user_name_locales(
  command: UserCommand,
  name_locales: List(#(Locale, String)),
) {
  UserCommand(..command, name_locales:)
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

pub fn message_command(
  name name: String,
  integrations integration_types: List(Integration),
  contexts contexts: List(InteractionContext),
) {
  MessageCommand(
    name:,
    name_locales: [],
    integration_types:,
    contexts:,
    nsfw: False,
  )
}

pub fn message_name_locales(
  command: MessageCommand,
  name_locales: List(#(Locale, String)),
) {
  MessageCommand(..command, name_locales:)
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
  description description: String,
  integrations integration_types: List(Integration),
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
