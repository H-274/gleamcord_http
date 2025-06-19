import entities/integration.{type Integration}
import entities/interaction_context.{type InteractionContext}
import entities/locale.{type Locale}

pub opaque type Command {
  User(UserCommand, Execute)
  Message(MessageCommand, Execute)
  Text(TextCommand)
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
  User(command, UserExecute(execute))
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
  Message(command, MessageExecute(execute))
}

/// TODO
pub type TextCommand

pub type Execute {
  UserExecute(UserExecute)
  MessageExecute(MessageExecute)
  TextExecute
}

pub type UserExecute =
  fn(String) -> String

pub type MessageExecute =
  fn(String) -> String
