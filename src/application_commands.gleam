//// Based on:
//// - https://discord.com/developers/docs/interactions/application-commands#application-command-object

import gleam/dict.{type Dict}
import internal/type_utils

pub opaque type AplicationCommand {
  ChatInput(signature: Signature, handler: ChatInputHandler)
  ChatInputGroup(
    name: String,
    description: String,
    subcommands: List(
      type_utils.Or(ChatInputSubcommandGroup, ChatInputSubcommand),
    ),
  )
  User(signature: Signature, handler: UserHandler)
  Message(signature: Signature, handler: MessageHandler)
}

pub fn chat_input(
  signature signature: Signature,
  handler handler: ChatInputHandler,
) {
  ChatInput(signature:, handler:)
}

pub fn chat_input_group(name: String, description: String) {
  ChatInputGroup(name:, description:, subcommands: [])
}

pub fn add_subcommand_group(
  command: AplicationCommand,
  subcommand_group: ChatInputSubcommandGroup,
) {
  case command {
    ChatInputGroup(_, _, subcommands) ->
      ChatInputGroup(..command, subcommands: [
        type_utils.A(subcommand_group),
        ..subcommands
      ])
    _ -> command
  }
}

pub fn add_subcommand(
  command: AplicationCommand,
  subcommand: ChatInputSubcommand,
) {
  case command {
    ChatInputGroup(_, _, subcommands) ->
      ChatInputGroup(..command, subcommands: [
        type_utils.B(subcommand),
        ..subcommands
      ])
    _ -> command
  }
}

pub fn user(signature: Signature, handler: UserHandler) {
  User(signature:, handler:)
}

pub fn message(signature: Signature, handler: MessageHandler) {
  Message(signature:, handler:)
}

pub opaque type ChatInputSubcommandGroup {
  ChatInputSubcommandGroup(
    name: String,
    description: String,
    subcommands: List(ChatInputSubcommand),
  )
}

pub fn subcommand_group(
  name: String,
  description: String,
  subcommands: List(ChatInputSubcommand),
) {
  ChatInputSubcommandGroup(name:, description:, subcommands:)
}

pub opaque type ChatInputSubcommand {
  ChatInputSubcommand(signature: Signature, handler: ChatInputHandler)
}

pub fn subcommand(
  signature signature: Signature,
  handler handler: ChatInputHandler,
) {
  ChatInputSubcommand(signature:, handler:)
}

pub opaque type Signature {
  Signature(
    name: String,
    description: String,
    options: List(Nil),
    permissions: Nil,
    integration_types: List(Nil),
    contexts: List(Nil),
    nsfw: Bool,
  )
}

pub fn signature(name: String, description: String) {
  Signature(
    name:,
    description:,
    options: [],
    permissions: Nil,
    integration_types: [Nil],
    contexts: [Nil, Nil],
    nsfw: False,
  )
}

pub fn set_options(signature: Signature, options: List(Nil)) {
  Signature(..signature, options:)
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

pub type ChatInputHandler =
  fn(Nil, Dict(String, ChatInputOptionValue)) -> String

pub type ChatInputOptionValue {
  StringValue(value: String)
  IntegerValue(value: Int)
  BooleanValue(value: Bool)
  UserValue(value: Int)
  ChannelValue(value: Int)
  RoleValue(value: Int)
  MentionableValue(value: Int)
  NumberValue(value: Float)
  AttachmentValue(value: Int)
}

pub type UserHandler {
  UserHandler
}

pub type MessageHandler {
  MessageHandler
}
