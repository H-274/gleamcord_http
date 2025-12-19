//// Based on:
//// - https://discord.com/developers/docs/interactions/application-commands#application-command-object

import gleam/dict.{type Dict}
import internal/type_utils

/// TODO: Replace signature types with signature values
/// unless we want a builder to make the signatures
pub opaque type AplicationCommand {
  ChatInput(signature: ChatInputSignature, handler: ChatInputHandler)
  ChatInputGroup(
    name: String,
    description: String,
    subcommands: List(
      type_utils.Or(ChatInputSubcommandGroup, ChatInputSubcommand),
    ),
  )
  User(signature: UserSignature, handler: UserHandler)
  Message(signature: MessageSignature, handler: MessageHandler)
}

pub fn chat_input(
  signature signature: ChatInputSignature,
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

pub fn user(signature: UserSignature, handler: UserHandler) {
  User(signature:, handler:)
}

pub fn message(signature: MessageSignature, handler: MessageHandler) {
  Message(signature:, handler:)
}

pub type ChatInputSubcommandGroup {
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
  ChatInputSubcommand(signature: ChatInputSignature, handler: ChatInputHandler)
}

pub fn subcommand(
  signature signature: ChatInputSignature,
  handler handler: ChatInputHandler,
) {
  ChatInputSubcommand(signature:, handler:)
}

pub type ChatInputSignature {
  ChatInputSignature(
    name: String,
    description: String,
    options: List(Nil),
    permissions: Nil,
    integration_types: List(Nil),
    contexts: List(Nil),
    nsfw: Bool,
  )
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

pub type UserSignature {
  UserSignature(
    name: String,
    description: String,
    permissions: Nil,
    integration_types: List(Nil),
    contexts: List(Nil),
    nsfw: Bool,
  )
}

pub type UserHandler {
  UserHandler
}

pub type MessageSignature {
  MessageSignature(
    name: String,
    description: String,
    options: List(Nil),
    permissions: Nil,
    integration_types: List(Nil),
    contexts: List(Nil),
    nsfw: Bool,
  )
}

pub type MessageHandler {
  MessageHandler
}
